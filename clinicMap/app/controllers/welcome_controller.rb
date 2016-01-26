include WelcomeHelper
require 'rest-client'

class WelcomeController < ApplicationController
  respond_to :json
  def index
    # import_csv_data
    # @cpcs = Clinic.all
  end

  def getGeoLocation
    p "======INSIDE GET GEO LOCATION======="
    name = params[:name]
    full_address = params[:full_address].split(' ')
    full_address = full_address.join('+')
    response = RestClient.get "https://maps.googleapis.com/maps/api/geocode/json?address=#{full_address}&key=AIzaSyDBsnO1kJI8VpBFeRTSQjVXykPPpWGtJAY"
    respond_with(response)
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




