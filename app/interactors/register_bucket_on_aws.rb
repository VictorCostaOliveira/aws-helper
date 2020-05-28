class RegisterBucketOnAws
  include Interactor::Organizer

  organize CreateBucket, CreateIamUser, CreateIamPolicy, AttachUserToPolicy, CreateUserAccessKey

end
