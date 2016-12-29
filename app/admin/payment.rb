ActiveAdmin.register Payment do
      belongs_to :claim, :optional => true
end
