FactoryGirl.define do
  factory :event do
    content_en "<img src=\"/uploads/image/201311/\" ..."
    content_jp "<img src=\"/uploads/image/201311/\" ..."
    content_zh "<img src=\"/uploads/image/201311/\" ..."
    content_tw "<img src=\"/uploads/image/201311/\" ..."
    enabled true
    admin_user_id nil
    start_at nil
    end_at nil
  end
end