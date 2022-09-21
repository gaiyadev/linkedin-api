class Post < ApplicationRecord
    belongs_to :user

    validates :title, 
     presence: { 
        scope: :title, 
        message: "Title is required"
     } ,
     length: {
         minimum: 3, 
        too_short: "Title is too short"
    },

    uniqueness: false

    validates :description,   
     presence: { 
        scope: :description, 
        message: "description is required"
     } ,
    length: { 
        minimum: 3, 
        too_short: "description is too short" 
    }
end
