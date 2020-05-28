class CreateUserAccessKey
  include Interactor

  def call
    puts "=====> CreateUserAccessKey... #{context}"
    iam = iam_client
    resp = iam.create_access_key({
      user_name: context.iam_user.user_name,
    })
    context.user_credentials = resp.to_h
  end

  private

  def iam_client
    @iam ||= Aws::IAM::Client.new(region: 'us-east-1', credentials: aws_credentials)
  end

  def aws_credentials
    @credentials ||= Aws::Credentials.new(Rails.application.credentials.aws[:aws_helper_access_key_id],
                                          Rails.application.credentials.aws[:aws_helper_secret_access_key])
  end
end
