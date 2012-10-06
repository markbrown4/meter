class TripsController < ApplicationController

  expose(:trips) { Trip.all }
  expose(:trip)

end
