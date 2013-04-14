require 'rubygems'
require 'roo'
require 'csv'

# load utilization in to array of hash
def utilized
	utilized = Roo::Excel.new('/Users/sparafina/projects/npanxx_check/utilized.xls')
	utilized.default_sheet = utilized.sheets[0]
    npanxx = Array.new


	headers = Hash.new
	utilized.row(1).each_with_index {|header,i|
		headers[header] = i
	}

	((utilized.first_row + 1)..utilized.last_row).each do |row|
		state = utilized.row(row)[headers['State']]
		npa = utilized.row(row)[headers['NPA']]
		nxx = utilized.row(row)[headers['NXX']]
		use = utilized.row(row)[headers['Use']]
		ocn = utilized.row(row)[headers['OCN']]
		company_name = utilized.row(row)[headers['Company Name']]
		rate_center = utilized.row(row)[headers['Rate Center']]
		initial_growth = utilized.row(row)[headers['Initial/Growth']]
		assigned_date = utilized.row(row)[headers['Assigned Date']]
		effective_date = utilized.row(row)[headers['Effective Date']]
		pooled_code = utilized.row(row)[headers['Pooled Code']]

		npanxx.push([state, npa, nxx, use, ocn, company_name, rate_center, initial_growth, assigned_date, effective_date, pooled_code])
	end

	return npanxx
end

def clean_phone_number(phone)
	phone.tr('0-9','')
	return phone
end


npanxx = utilized


CSV.foreach("phones.csv") do |row|
	phone = clean_phone_number(row[0])
    npa = phone.slice(0..2)
    nxx = phone.slice(4..6)

    npanxx.each do |line|
    	u_nxx = line.fetch(2)
    	if nxx == u_nxx
    		record = row += line
    		puts record.join(",")
    	end
    end
end