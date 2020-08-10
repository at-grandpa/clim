require "./../../../spec_helper"

describe "bash completion." do
  [
    {
      input:    "bash_sample ",
      expected: <<-EXPECTED
      --help        --version     sub1          sub2          
      --opt-main-a  -a            sub1_alias1   sub2_alias1   
      --opt-main-b  -v            sub1_alias2   sub2_alias2   

      EXPECTED
    },
    {
      input:    "bash_sample -",
      expected: <<-EXPECTED
      --help        --opt-main-b  -a            
      --opt-main-a  --version     -v            

      EXPECTED
    },
    {
      input:    "bash_sample --",
      expected: <<-EXPECTED
      --help        --opt-main-a  --opt-main-b  --version     

      EXPECTED
    },
    {
      input:    "bash_sample sub",
      expected: <<-EXPECTED
      sub1         sub1_alias1  sub1_alias2  sub2         sub2_alias1  sub2_alias2

      EXPECTED
    },
    {
      input:    "bash_sample sub1 ",
      expected: <<-EXPECTED
      --help            -a                sub1_sub2         
      --opt-sub1-a      -h                sub1_sub2_alias1  
      --opt-sub1-b      sub1_sub1         sub1_sub2_alias2  

      EXPECTED
    },
    {
      input:    "bash_sample sub1_alias2 ",
      expected: <<-EXPECTED
      --help            -a                sub1_sub2         
      --opt-sub1-a      -h                sub1_sub2_alias1  
      --opt-sub1-b      sub1_sub1         sub1_sub2_alias2  

      EXPECTED
    },
  ].each do |spec_case|
    it "input: #{spec_case[:input]}" do
      `docker run --rm -it -v $(PWD):/tmp -w /tmp crystallang/crystal:latest /bin/bash -c "make build -C spec/clim/completion/display/ PROGRAM_NAME=bash_sample INPUT='#{spec_case[:input]}'"`
      File.read("#{__DIR__}/output").should eq spec_case[:expected]
    end
  end
end
