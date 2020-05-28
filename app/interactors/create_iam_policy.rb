class CreateIamPolicy
  include Interactor

  def call
    puts "=====> CreateIamPolicy... #{context}"
    create
  end

  private

  def create
    iam = iam_client
    policy_name = context.policy_name
    begin
      create_policy_response = iam.create_policy({
        policy_name: policy_name,
        policy_document: policy_document
      })
      iam.wait_until(:policy_exists, policy_arn: create_policy_response.policy.arn)
      context.policy_arn = create_policy_response.policy.arn
    rescue Aws::IAM::Errors::EntityAlreadyExists
      context.fail!(error: [I18n.t('interactors.create_iam_policy.already_exists', policy_name: policy_name)])
    end
  end

  def policy_document
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": "arn:aws:s3:::#{context.name}/*"
        }
      ]
    }.to_json
  end

  def iam_client
    @iam ||= Aws::IAM::Client.new(region: 'us-east-1', credentials: aws_credentials)
  end

  def aws_credentials
    @credentials ||= Aws::Credentials.new(Rails.application.credentials.aws[:aws_helper_access_key_id],
                                          Rails.application.credentials.aws[:aws_helper_secret_access_key])
  end
end
