use strict;
use warnings;
use lib 'inc';
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'ZT',
    license           => 'perl',
    dist_author       => q{kthakore <kthakore@cpan.org>},
    dist_abstract     => 'Zombie trap is awesome stuff',
    dist_version_from => 'lib/ZT.pm',
    build_requires    => {
        'Test::More'                    => 0,
        'Box2D'                         => 0,
        'SDL'                           => 0,
        'FindBin'                       => 0,
        'Modern::Perl'                  => 0,
        'Moose'                         => 0,
        'MooseX::Storage'               => 0,
        'MooseX::Storage::Format::JSON' => 0,
        'SDLx::Widget'                  => 0,
    },
    add_to_cleanup       => ['ZT-*'],
    extra_compiler_flags => '-I src',
    extra_linker_flags   => 'src/zt.c',
    create_makefile_pl   => 'traditional',
);

$builder->create_build_script();
