class HealthCheckController < ApplicationController
  def healthz
    render json: { status: "ok" }
  end
end
