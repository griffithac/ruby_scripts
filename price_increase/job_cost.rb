#  cost data fields
#  
#
#

class JobCost
  
  def initialize qb_file, access_file, start_date = (Date.now - 3.days), end_date = (Date.now)
    @start_date = start_date
    @end_date = end_date
    @qb_file = qb_file
    @qb_db_connection = # quickbooks database xml connection
    @access_db_connection
  end
  
  def get_mf_job_list
    # code to query qb for jobs done in that prior week with the Template "MF INV" 
  end
  
  def load_labor_cost_data
    @cost_data = Array.new
  end
  
  def load_sell_data
    @sell_data = Array.new
  end
  
  def build_report
      
  end

end