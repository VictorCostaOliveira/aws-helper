class CreateBucket
  include Interactor

  def call
    puts "=====> CreateBucket... #{context}"
    s3 = s3_client
    bucket_options = {
      bucket: context.name
    }
    s3.create_bucket(bucket_options)
  end

  private

  def s3_client
    @s3 ||= Aws::S3::Client.new(region: 'us-east-1', credentials: aws_credentials)
  end

  def aws_credentials
    @credentials ||= Aws::Credentials.new(Rails.application.credentials.aws[:aws_helper_access_key_id],
                                          Rails.application.credentials.aws[:aws_helper_secret_access_key])
  end
end
