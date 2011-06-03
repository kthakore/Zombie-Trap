use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'ZT',
    license             => 'perl',
    dist_author         => q{kthakore <kthakore@cpan.org>},
    dist_version_from		=> 'lib/ZT.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'ZT-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
