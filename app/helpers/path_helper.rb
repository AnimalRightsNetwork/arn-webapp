module PathHelper
  # Custom organization paths
  def org_path org, options={}
    org_url org, options.merge(only_path: true)
  end

  def org_url org, options={}
    url_for(options.merge(controller: :orgs, action: :show, id: org.display_id))
  end

  # Custom user paths
  def user_path user, options={}
    user_url user, options.merge(only_path: true)
  end

  def user_url user, options={}
    url_for(options.merge(controller: :users, action: :show, id: user.display_id))
  end
end
