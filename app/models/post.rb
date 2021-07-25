class Post < ApplicationRecord
  enum send_result: { Delivery: 1, Complaint: 2,  Bounce: 3 }
end
