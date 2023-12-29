class Api::V1::PaymentController < ApiController
    protect_from_forgery with: :null_session

    include ApiResponse
  
    def handle_payment
      booking = Booking.find_by(id: params[:booking_id])

      return render_error('Booking not found') unless booking

      booking_method = params[:booking_method]
      service_ids = params[:booking_services]
      has_insurance = params[:has_insurance]

      services = Service::where(id: service_ids)

      start_date = booking.booking_start
      end_date = booking.booking_end
      consumption_tax = 10
      tax_amount = (booking.car_price + services.sum(&:price)) * consumption_tax / 100
      total_amount = booking.car_price + services.sum(&:price) + tax_amount

      conflict_booking = Booking::where(car_id: booking.car_id)
        .where.not(id: booking.id)
        .where(booking_status: [11, 12])
        .where("(booking_start BETWEEN ? AND ?) OR (booking_end BETWEEN ? AND ?)", start_date, end_date, start_date,end_date)

      if conflict_booking.present?
        return render_error('Car already booked') 
      end

      service_ids.each do |service_id|
        booking.services << Service.find_by(id: service_id)
      end

      booking_services_price = services.sum(&:price)

      booking.update(
        service_price: booking_services_price,
        has_insurance: has_insurance,
        booking_status: 11
      )
  
      # Process other parts of payment logic
      existing_payment = Payment.find_or_initialize_by(booking_id: booking.id)

      if(existing_payment && existing_payment.payment_method == 1)
        return render_error('A payment via bank transfer already exists for this reservation')
      end

      if(booking.booking_status == 40)
        return render_error('Booking has been canceled')
      end
  
      existing_payment.update(
        amount: total_amount,
        payment_status: 0,
        payment_method: 0
      )

      tax_rates = create_stripe_tax_rate(consumption_tax)
  
      car_image_url = 'https://img1.oto.com.vn/2023/05/09/OpzfnMD2/glc300-5dcd.jpg'
  
      session = create_stripe_checkout_session(booking, car_image_url, tax_rates)

      return render_error('Stripe checkout session creation failed.') unless session['id'].present?

      existing_payment.update(
          stripe_session_id: session['id'],
          payment_status: 1
      )
  
      return render json: { data: session }
    end
  
    def create_stripe_payment
      # Implementation for creating a Stripe payment

    end
  
    def create_stripe_checkout_session(booking, car_image_url, tax_rates)
      Stripe::Checkout::Session.create({
        customer_email: booking.user.email,
        mode: 'payment',
        line_items: [{
          price_data: {
            currency: 'USD',
            product_data: {
              name: booking.car.name,
              images: [car_image_url],
            },
            unit_amount: booking.car_price * 100,
          },
          quantity: 1,
          tax_rates: [tax_rates.id]
        }],
        success_url: api_v1_bookings_url,
        cancel_url: api_v1_bookings_url,
      })
    end
  
    private
  
    def create_stripe_tax_rate(consumption_tax)
      Stripe::TaxRate.create(
        display_name: 'Consumption tax',
        inclusive: false,
        percentage: consumption_tax,
        country: 'JP',
        jurisdiction: 'JP',
        description: "Consumption tax (#{consumption_tax}%)"
      )
    end
  end
  