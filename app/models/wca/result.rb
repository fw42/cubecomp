#!/usr/bin/ruby

class Wca::Result < ActiveRecord::Base
  establish_connection :wca
  self.table_name = "Results"
end
