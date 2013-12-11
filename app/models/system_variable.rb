class SystemVariable <  ActiveRecord::Base
  #attr_accessible :name, :value

  def self.latest_version_name
    find_by_name('latest_version_name').try(:value)
  end

  def self.base_build
    find_by_name('base_build').try(:value)
  end

  def self.latest_build
    find_by_name('lastest_build').try(:value)
  end

  def self.latest_version_desc
    h = {}
    %w(en jp zh tw).each do |lang|
      h[lang] = find_by_name("latest_version_desc_#{lang}").try(:value)
    end
    h
  end

end
