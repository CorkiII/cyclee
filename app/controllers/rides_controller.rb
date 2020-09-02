require 'json'
require 'yaml'

class RidesController < ApplicationController
  before_action :set_ride, only: [:show, :edit, :update]

  def index
    @rides = Ride.select(:destination_address).map(&:destination_address).uniq
  end

  def search
    @last_ride = current_user.rides.last
    @parking = @last_ride.parking
    results = Geocoder.search([@parking.latitude, @parking.longitude])
    @address_parking = results.first.address
    if params[:query].present?
      results = Geocoder.search(params[:query])
      # @ride = Ride.create(destination_address: params[:query])
      @markers = [{ lat: results.first.coordinates.first, lng: results.first.coordinates.last }]
      @ride = Ride.new
    end
  end

  def create
    @ride = Ride.new(ride_params)
    @ride.user = current_user
    if @ride.save
      redirect_to edit_ride_path(@ride)
    else
      render :search
    end
  end

  def edit
    @cycling_waypoints = get_waypoints(@ride, 'cycling')[0]['routes'][0]['geometry']['coordinates']
    @cycling_waypoints_alt = get_waypoints(@ride, 'cycling')[0]['routes'][1]['geometry']['coordinates']
    @duration = (get_waypoints(@ride, 'cycling')[0]['routes'][0]['duration'] / 60).ceil
    @duration_alt = (get_waypoints(@ride, 'cycling')[0]['routes'][1]['duration'] / 60).ceil
    @markers = [
      # { lat: @cycling_waypoints.first[1], lng: @cycling_waypoints.first[0] },
      { lat: @cycling_waypoints.last[1], lng: @cycling_waypoints.last[0] }
    ]
  end

  def update
    @ride.update(ride_params)
    redirect_to ride_path(@ride)
  end

  def show
    @markers = [{ lat: @ride.destination_latitude, lng: @ride.destination_longitude }]
    @danger = Danger.new
    @markers_danger = @ride.dangers.map do |danger|
      {
        lat: danger.latitude,
        lng: danger.longitude,
        cat: danger.category
      }
    end
    # @distance = Geocoder::Calculations.distance_between([@ride.origin_latitude,@ride.origin_longitude], [@ride.destination_latitude, @ride.destination_longitude])
    if @ride.bike_friendly
      data = get_waypoints(@ride, 'cycling')
      @cycling_waypoints = data[0]['routes'][1]['geometry']['coordinates']
      @color = '#ef596e'
    else
      data = get_waypoints(@ride, 'cycling')
      @cycling_waypoints = data[0]['routes'][0]['geometry']['coordinates']
      @color = '#193c60'
    end
    @duration = data[0]['routes'][0]['duration'] / 60
    @distance = data[0]['routes'][0]['distance'] / 1000
  end

  private

  def ride_params
    params.require(:ride).permit(:origin_latitude, :origin_longitude, :destination_address, :destination_longitude, :destination_latitude, :bike_friendly)
  end

  def set_ride
    @ride = Ride.find(params[:id])
  end
end
