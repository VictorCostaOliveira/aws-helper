class BucketsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_bucket, only: [:show, :edit, :update, :destroy]

  def index
    @buckets = Bucket.all
  end

  def show
  end

  def new
    @bucket = Bucket.new
  end

  def edit
  end

  def create
    @bucket = Bucket.new(bucket_params)
    if @bucket.save
      interactor_response = RegisterBucketOnAws.call(bucket_params)
      if interactor_response.success?
        flash[:notice] = I18n.t('controllers.buckets.create.bucket_created', bucket_name: @bucket.name)
        redirect_to @bucket
      else
        flash[:alert] = interactor_response.error.joins(" ")
      end
    else
      flash[:alert] = @bucket.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def set_bucket
    @bucket = Bucket.find(params[:id])
  end

  def bucket_params
    params.require(:bucket).permit(:name, :policy_name, :bucket_user_name)
  end
end
