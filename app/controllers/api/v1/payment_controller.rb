class Api::V1::PaymentController < ApiController
    protect_from_forgery with: :null_session
    def handle_payment
        booking = Booking::find(params[:booking_id])
        start_date = booking.booking_start
        end_date = booking.booking_end
        return render json:{data: params[:booking_services]}

        payment = Payment.find_or_initialize_by(booking_id: booking.id)

        payment.update(
            amount: booking.car_price,
            payment_status: 0,
            payment_method: 0
        )
        consumption_tax = 10

        tax_rates = Stripe::TaxRate.create(
            display_name: '消費税',
            inclusive: false,
            percentage: consumption_tax,
            country: 'JP',
            jurisdiction: 'JP',
            description: "消費税 (#{consumption_tax}%)"
        )

        car_image_url = 'https://img1.oto.com.vn/2023/05/09/OpzfnMD2/glc300-5dcd.jpg'

        session = Stripe::Checkout::Session.create({
            customer_email:  booking.user.email,
            mode: 'payment',
            line_items: [{
                price_data: {   
                    currency: 'USD', 
                    product_data:{ 
                        name: car_name = booking.car.name, 
                        images: [car_image_url],
                }, 
                unit_amount: booking.car_price,
                },
                quantity: 1,
                tax_rates: [tax_rates.id]
            }],
            success_url: api_v1_bookings_url,
            cancel_url: api_v1_bookings_url,
        })
        return render json:{data: session}
        # redirect_to session.url, allow_other_host: true
    end

    def create_stripe_payment

    end

    def create_stripe_checkout_session

    end
end