# frozen_string_literal: true

class HealthController < ApplicationController
  def index
    render :ok, json: { ok: true }
  end
end
