require 'spec_helper'

describe 'nodejs::install', :type => :define do
  let(:title) { 'nodejs::install' }
  let(:facts) {{
    :nodejs_stable_version => 'v0.10.20'
  }}

  describe 'with default parameters' do
    
    let(:params) {{ }}

    it { should contain_file('nodejs-install-dir') \
      .with_ensure('directory')
    }

    it { should contain_wget__fetch('nodejs-download-v0.10.20') \
      .with_source('http://nodejs.org/dist/v0.10.20/node-v0.10.20.tar.gz') \
      .with_destination('/usr/local/node/node-v0.10.20.tar.gz')
    }

    it { should contain_file('nodejs-check-tar-v0.10.20') \
      .with_ensure('file') \
      .with_path('/usr/local/node/node-v0.10.20.tar.gz')
    }

    it { should contain_exec('nodejs-unpack-v0.10.20') \
      .with_command('tar -xzvf node-v0.10.20.tar.gz -C /usr/local/node/node-v0.10.20 --strip-components=1') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -f /usr/local/node/node-v0.10.20/bin/node')
    }

    it { should contain_file('/usr/local/node/node-v0.10.20') \
      .with_ensure('directory')
    }

    it { should contain_exec('nodejs-make-install-v0.10.20') \
      .with_command('./configure --prefix=/usr/local/node/node-v0.10.20 && make && make install') \
      .with_cwd('/usr/local/node/node-v0.10.20') \
      .with_unless('test -f /usr/local/node/node-v0.10.20/bin/node')
    }

    it { should contain_file('nodejs-symlink-bin-with-version-v0.10.20') \
      .with_ensure('link') \
      .with_path('/usr/local/bin/node-v0.10.20') \
      .with_target('/usr/local/node/node-v0.10.20/bin/node')
    }

    it { should_not contain_file('/usr/local/bin/node') }
    it { should_not contain_file('/usr/local/bin/npm') }

    it { should_not contain_wget__fetch('npm-download-v0.10.20') }
    it { should_not contain_exec('npm-install-v0.10.20') }
  end

  describe 'with specific version v0.10.19' do

    let(:params) {{
      :version => 'v0.10.19'
    }}

    it { should contain_file('nodejs-install-dir') \
      .with_ensure('directory')
    }

    it { should contain_wget__fetch('nodejs-download-v0.10.19') \
      .with_source('http://nodejs.org/dist/v0.10.19/node-v0.10.19.tar.gz') \
      .with_destination('/usr/local/node/node-v0.10.19.tar.gz')
    }

    it { should contain_file('nodejs-check-tar-v0.10.19') \
      .with_ensure('file') \
      .with_path('/usr/local/node/node-v0.10.19.tar.gz')
    }

    it { should contain_exec('nodejs-unpack-v0.10.19') \
      .with_command('tar -xzvf node-v0.10.19.tar.gz -C /usr/local/node/node-v0.10.19 --strip-components=1') \
      .with_cwd('/usr/local/node') \
      .with_unless('test -f /usr/local/node/node-v0.10.19/bin/node')
    }

    it { should contain_file('/usr/local/node/node-v0.10.19') \
      .with_ensure('directory')
    }

    it { should contain_exec('nodejs-make-install-v0.10.19') \
      .with_command('./configure --prefix=/usr/local/node/node-v0.10.19 && make && make install') \
      .with_cwd('/usr/local/node/node-v0.10.19') \
      .with_unless('test -f /usr/local/node/node-v0.10.19/bin/node')
    }

    it { should contain_file('nodejs-symlink-bin-with-version-v0.10.19') \
      .with_ensure('link') \
      .with_path('/usr/local/bin/node-v0.10.19') \
      .with_target('/usr/local/node/node-v0.10.19/bin/node')
    }

    it { should_not contain_file('/usr/local/bin/node') }
    it { should_not contain_file('/usr/local/bin/npm') }

    it { should_not contain_wget__fetch('npm-download-v0.10.19') }
    it { should_not contain_exec('npm-install-v0.10.19') }
  end


  describe 'with a given target_dir' do
    let(:params) {{
      :target_dir => '/bin'
    }}

    it { should contain_file('nodejs-symlink-bin-with-version-v0.10.20') \
      .with_ensure('link') \
      .with_path('/bin/node-v0.10.20') \
      .with_target('/usr/local/node/node-v0.10.20/bin/node')
    }
  end

  describe 'without NPM' do
    let(:params) {{
      :with_npm => false
    }}

    it { should_not contain_exec('npm-download-v0.10.20') }
    it { should_not contain_exec('npm-install-v0.10.20') }
  end

  describe 'with make_install = false' do
    let(:params) {{
      :make_install => false
    }}

    it { should_not contain_exec('nodejs-make-install-v0.10.20') }
  end
end
