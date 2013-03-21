require 'spec_helper'

describe Club do
  it { should validate_presence_of :club_name   }

end
