require "spec"

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
    {
      input:    "bash_sample sub1 sub1_sub2 ",
      expected: <<-EXPECTED
      --help             --opt-sub1-sub2-b  sub1_sub2_sub1     
      --opt-sub1-sub2-a  -a                 sub1_sub2_sub2     

      EXPECTED
    },
    {
      input:    "bash_sample sub1 sub1_sub2_alias2 ",
      expected: <<-EXPECTED
      --help             --opt-sub1-sub2-b  sub1_sub2_sub1     
      --opt-sub1-sub2-a  -a                 sub1_sub2_sub2     

      EXPECTED
    },
    {
      input:    "bash_sample sub1 sub1_sub2_alias2 sub1_sub2_sub2 -",
      expected: <<-EXPECTED
      --help                  --opt-sub1-sub2-sub2-b  -p
      --opt-sub1-sub2-sub2-a  -a                      

      EXPECTED
    },
    {
      input:    "bash_sample sub2_alias2 ",
      expected: <<-EXPECTED
      --help        --opt-sub2-a  --opt-sub2-b  -a            sub2_sub1

      EXPECTED
    },
  ].each do |spec_case|
    it "program_name: bash_sample, input: #{spec_case[:input]}" do
      `docker run --rm -it -v $(PWD):/tmp -w /tmp crystallang/crystal:latest /bin/bash -c "make build -C spec_completion/bash/ FILE_NAME=bash_sample PROGRAM_NAME=bash_sample INPUT='#{spec_case[:input]}'"`
      File.read("#{__DIR__}/output").should eq spec_case[:expected]
    end
  end

  [
    {
      input:    "my_cli ",
      expected: <<-EXPECTED
      --help        --version     sub1          sub2          
      --opt-main-a  -a            sub1_alias1   sub2_alias1   
      --opt-main-b  -v            sub1_alias2   sub2_alias2   

      EXPECTED
    },
    {
      input:    "my_cli -",
      expected: <<-EXPECTED
      --help        --opt-main-b  -a            
      --opt-main-a  --version     -v            

      EXPECTED
    },
    {
      input:    "my_cli --",
      expected: <<-EXPECTED
      --help        --opt-main-a  --opt-main-b  --version     

      EXPECTED
    },
    {
      input:    "my_cli sub",
      expected: <<-EXPECTED
      sub1         sub1_alias1  sub1_alias2  sub2         sub2_alias1  sub2_alias2

      EXPECTED
    },
    {
      input:    "my_cli sub1 ",
      expected: <<-EXPECTED
      --help            -a                sub1_sub2         
      --opt-sub1-a      -h                sub1_sub2_alias1  
      --opt-sub1-b      sub1_sub1         sub1_sub2_alias2  

      EXPECTED
    },
    {
      input:    "my_cli sub1_alias2 ",
      expected: <<-EXPECTED
      --help            -a                sub1_sub2         
      --opt-sub1-a      -h                sub1_sub2_alias1  
      --opt-sub1-b      sub1_sub1         sub1_sub2_alias2  

      EXPECTED
    },
    {
      input:    "my_cli sub1 sub1_sub2 ",
      expected: <<-EXPECTED
      --help             --opt-sub1-sub2-b  sub1_sub2_sub1     
      --opt-sub1-sub2-a  -a                 sub1_sub2_sub2     

      EXPECTED
    },
    {
      input:    "my_cli sub1 sub1_sub2_alias2 ",
      expected: <<-EXPECTED
      --help             --opt-sub1-sub2-b  sub1_sub2_sub1     
      --opt-sub1-sub2-a  -a                 sub1_sub2_sub2     

      EXPECTED
    },
    {
      input:    "my_cli sub1 sub1_sub2_alias2 sub1_sub2_sub2 -",
      expected: <<-EXPECTED
      --help                  --opt-sub1-sub2-sub2-b  -p
      --opt-sub1-sub2-sub2-a  -a                      

      EXPECTED
    },
    {
      input:    "my_cli sub2_alias2 ",
      expected: <<-EXPECTED
      --help        --opt-sub2-a  --opt-sub2-b  -a            sub2_sub1

      EXPECTED
    },
  ].each do |spec_case|
    it "program_name: my_cli, input: #{spec_case[:input]}" do
      `docker run --rm -it -v $(PWD):/tmp -w /tmp crystallang/crystal:latest /bin/bash -c "make build -C spec_completion/bash/ FILE_NAME=bash_sample PROGRAM_NAME=my_cli INPUT='#{spec_case[:input]}'"`
      File.read("#{__DIR__}/output").should eq spec_case[:expected]
    end
  end
end
