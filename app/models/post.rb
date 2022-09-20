class Post < ApplicationRecord
         validates :title, 
     presence: { 
        scope: :title, 
        message: "Title is required"
     } ,
     length: {
         minimum: 3, 
        too_short: "Title is too short"
    },
    uniqueness: { scope: :title,
        message: "title already exist" }

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
