class CreateIamUser
  include Interactor

  def call
    puts "=====> CreateIamUser... #{context}"
    iam = iam_client
    @user_name = context.bucket_user_name
    begin
      create_iam_user_response = iam.create_user(user_name: @user_name)
      iam.wait_until(:user_exists, user_name: @user_name)

      arn_parts = create_iam_user_response.user.arn.split(':')
      context.iam_user = create_iam_user_response.user
    rescue Aws::IAM::Errors::EntityAlreadyExists
      context.fail!(error: [I18n.t('interactors.create_iam_user.user_exists', bucket_user_name: @user_name)])
    end
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
