include WelcomeHelper
require 'rest-client'

class WelcomeController < ApplicationController
  respond_to :json
  def index
    import_csv_data
    # @cpcs = Clinic.all
  end


  def getGeoLocations
    "======INSIDE GET GEO LOCATION======="
    @clinics = Clinic.where(lat:nil)

    @clinics.each do |clinic_obj|
      if clinic_obj.lat
      else

        full_address = clinic_obj.full_address.gsub(/[,.-]/, '')
        full_address = full_address.split(/[\W]/).join('+')
        response = RestClient.get "https://maps.googleapis.com/maps/api/geocode/json?address=#{full_address}&key=AIzaSyDBsnO1kJI8VpBFeRTSQjVXykPPpWGtJAY"
        response = JSON.parse(response)
        clinic = clinic_obj
        if (response["status"] != "ZERO_RESULTS")
          clinic.lat = response["results"][0]["geometry"]["location"]["lat"]
          clinic.lng = response["results"][0]["geometry"]["location"]["lng"]
          clinic.save
        else
        end
      end
    end
    redirect '/'

  end

  def getClinic
    p params[:id]
    clinic = Clinic.find(params[:id])
    p clinic
    clinic_hash = {name:"#{clinic.name}", full_address:"#{clinic.full_address}"}
    p clinic_hash
    return clinic.to_json
  end

  def allClinics
    p "======ALL-CLINICS-ROUTE======"
    @clinics = Clinic.all

  # @clinics.to_json
  respond_with(@clinics)

end

def saveLatLng
  p "=========saveLatLng-ROUTE=========="
  clinic = Clinic.find(params[:id])
  p params
  clinic.lat = params[:lat].to_f.round(8)
  clinic.lng = params[:lng].to_f.round(8)
  if clinic.save
    return "SAVED"
  else
    return "FAILED TO SAVE"
  end
end
# render :nothing => true
end




