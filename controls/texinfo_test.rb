title 'Tests to confirm texinfo works as expected'

plan_name = input('plan_name', value: 'texinfo')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
hab_path = input('hab_path', value: 'hab')

control 'core-plans-texinfo' do
  impact 1.0
  title 'Ensure texinfo works'
  desc '
  There are several binaries in the texinfo package.  We check that the help and version commands
  work as expected for a couple of these:

    $ info --version
    info --version
    info (GNU texinfo) 6.6

    Copyright (C) 2019 Free Software Foundation, Inc.
    ...

    $ info --help
    Usage: info [OPTION]... [MENU-ITEM...]

    Read documentation in Info format.
    ...

    $ install-info --version
    install-info (GNU texinfo) 6.6

    Copyright (C) 2019 Free Software Foundation, Inc.
    ...

    $ install-info --help
    Usage: install-info [OPTION]... [INFO-FILE [DIR-FILE]]
    ...

  '
  texinfo_pkg_ident = command("#{hab_path} pkg path #{plan_ident}")
  describe texinfo_pkg_ident do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  texinfo_pkg_ident = texinfo_pkg_ident.stdout.strip
  version_string = texinfo_pkg_ident.split('/')[5]

  describe command("#{texinfo_pkg_ident}/bin/info --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /info \(GNU texinfo\) #{version_string}/ }
    its('stderr') { should be_empty }
  end

  describe command("#{texinfo_pkg_ident}/bin/info --help") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Usage: info/ }
    its('stderr') { should be_empty }
  end

  describe command("#{texinfo_pkg_ident}/bin/install-info --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /install-info \(GNU texinfo\) #{version_string}/ }
    its('stderr') { should be_empty }
  end

  describe command("#{texinfo_pkg_ident}/bin/install-info --help") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Usage: install-info/ }
    its('stderr') { should be_empty }
  end

  describe command("#{texinfo_pkg_ident}/bin/makeinfo --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /texi2any \(GNU texinfo\) #{version_string}/ }
    its('stderr') { should be_empty }
  end

  describe command("#{texinfo_pkg_ident}/bin/makeinfo --help") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Usage: makeinfo/ }
    its('stderr') { should be_empty }
  end
end
