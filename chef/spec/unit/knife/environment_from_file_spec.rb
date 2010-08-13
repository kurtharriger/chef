#
# Author:: Stephen Delano (<stephen@ospcode.com>)
# Copyright:: Copyright (c) 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Chef::Knife::EnvironmentFromFile do
  before(:each) do
    @knife = Chef::Knife::EnvironmentFromFile.new
    @knife.stub!(:msg).and_return true
    @knife.stub!(:output).and_return true
    @knife.stub!(:show_usage).and_return true
    @knife.name_args = [ "spec.rb" ]

    @environment = Chef::Environment.new
    @environment.name("spec")
    @environment.description("runs the unit tests")
    @environment.cookbook_versions({"apt" => "1.2.3"})
    @environment.stub!(:save).and_return true
    @knife.stub!(:load_from_file).and_return @environment
  end

  describe "run" do
    it "should load from a file" do
      @knife.should_receive(:load_from_file)
      @knife.run
    end

    it "should save the environment" do
      @environment.should_receive(:save)
      @knife.run
    end

    it "should not print the environment" do
      @knife.should_not_receive(:output)
      @knife.run
    end

    it "should show usage and exit if not filename is provided" do
      @knife.name_args = []
      @knife.should_receive(:show_usage)
      lambda { @knife.run }.should raise_error(SystemExit)
    end

    describe "with --print-after" do
      it "should pretty print the environment, formatted for display" do
        @knife.config[:print_after] = true
        @knife.should_receive(:output)
        @knife.run
      end
    end
  end
end