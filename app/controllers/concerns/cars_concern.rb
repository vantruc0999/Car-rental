module CarsConcern
    extend ActiveSupport::Concern

    included do
        def render_car_data(car)
            data = car.as_json(
                include:{
                    brand:{
                        except: [:created_at, :updated_at],
                    },
                    car_model:{
                        except: [:created_at, :updated_at],
                    },
                },
                except: [:brand_id, :car_model_id, :created_at, :updated_at]
            )
        end
    end
end