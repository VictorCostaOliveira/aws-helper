class AttachUserToPolicy
  include Interactor

  def call
    puts "=====> AttachUserToPolicy... #{context}"
    iam = iam_client
    begin
      resp = iam.attach_user_policy({
        policy_arn: context.policy_arn,
        user_name: context.iam_user.user_name,
      })
    rescue Aws::IAM::Errors::PolicyNotAttachableException
      context.fail!(error: [I18n.t('interactors.attach_user_to_policy.attach_error', user_name: context.iam_user.user_name)])
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
