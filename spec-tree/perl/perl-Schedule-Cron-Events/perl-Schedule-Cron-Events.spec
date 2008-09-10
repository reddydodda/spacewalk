Name:           perl-Schedule-Cron-Events
Version:        1.8
Release:        13%{?dist}
Summary:        Take a line from a crontab and find out when events will occur
License:        GPL+ or Artistic
Group:          Development/Libraries
URL:            http://search.cpan.org/dist/Schedule-Cron-Events/
Source0:        http://www.cpan.org/modules/by-module/Schedule/Schedule-Cron-Events-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:  perl(Set::Crontab)
BuildArch:      noarch
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%description
Given a line from a crontab, tells you the time at which cron will next run
the line, or when the last event occurred, relative to any date you choose.
The object keeps that reference date internally, and updates it when you
call nextEvent() or previousEvent() - such that successive calls will give
you a sequence of events going forward, or backwards, in time.

%prep
%setup -q -n Schedule-Cron-Events-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT

make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} \;
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null \;

%{_fixperms} $RPM_BUILD_ROOT/*

%check
make test

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc README
%{_bindir}/cron_event_predict.plx 
%{perl_vendorlib}/*
%{_mandir}/man1/*
%{_mandir}/man3/*

%changelog
* Wed Sep 10 2008 Miroslav Suchý <msuchy@redhat.com>
- fix mixed tab and space

* Thu Sep  4 2008 Miroslav Suchý <msuchy@redhat.com> 1.8-12
- add build requires

* Fri Aug 29 2008 Miroslav Suchý <msuchy@redhat.com> 1.8-2
- Specfile autogenerated by cpanspec 1.77.
