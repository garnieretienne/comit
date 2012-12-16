class GitUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value =~ /(http|https|git):\/\/.*/ || Rails.env.test? # Tests need to be able to reach local git repository
      begin
        git = Grit::Git.new('.')
        if git.ls_remote({process_info: true, env: {"GIT_ASKPASS" => "echo"}}, value)[0] != 0
          record.errors[attribute] << "is not reachable (access denied or wrong url)"
        end
      rescue Grit::Git::GitTimeout
        record.errors[attribute] << "is not reachable (timeout exceeded)"
      end
    else
        record.errors[attribute] << (options[:message] || "is not a supported git url")
    end
  end
end