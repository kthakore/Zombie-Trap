package ZT;
use Modern::Perl;

use SDL;
use SDL::Event;
use SDL::Events; 
use SDLx::Surface;
use SDLx::Widget::Menu;

use Box2D;


use ZT::Util;
use ZT::Level; 
use ZT::State;
use ZT::Camera; 
use BoxSDL::Controller;



our $VERSION = '0.01';

sub start {
    
    my $app = ZT::Util::app(); 

    my $menu = SDLx::Widget::Menu->new( font => $ZT::Util::data_dir . '/font.ttf' );
    $menu->items(
            'New Game'  => sub { $app->stop(); level_loop(); $app->run()  },
            'Quit'      => sub { $app->stop();  }, #return the of this in event loop
            );

    $app->add_event_handler( sub { $menu->event_hook($_[0]);} );
    $app->add_show_handler( sub { $menu->render($app); $app->update();} );


    $app->run();

}

sub level_loop {
   
    my $index = 0;

    while( $index != -1 )
      {
            $index = game();
            warn "Index is $index";
      }

}

sub game {
    my $index = shift;
    my $fps      = 60.0;
    my $timestep = 0.1;
    my $vIters   = 8;
    my $pIters   = 8;

    my $gravity = Box2D::b2Vec2->new( 0, 9.8 );
    my $world = Box2D::b2World->new( $gravity, 1 );
    my $listener = Box2D::PerlContactListener->new();

    $listener->SetBeginContactSub(
            sub {
            my ($contact) = @_;

            my $bodyA = $contact->GetFixtureA->GetBody();
            my $bodyB = $contact->GetFixtureB->GetBody();

            foreach ( [ $bodyA, $bodyB ], [ $bodyB, $bodyA ] ) {
            my $data = $_->[0]->GetUserData();
            my $sub = $data->{cb} if defined $data->{cb};
            $sub->( $_->[1]->GetUserData->{self} ) if ref $sub eq 'CODE';
            }
            }
            );

    $world->SetContactListener($listener);
    my $controller = BoxSDL::Controller->new( 
            dt     => $timestep, 
            delay  => 10,
            min_t  => $timestep / 2,
            eoq    => 1,
            world  => $world,
            vIters => $vIters,
            pIters => $pIters, 
            c_f    => 1
            );

    my $state = ZT::Util::game_state( $controller );
    my $camera = ZT::Camera->new();

    my $level =  $state->next_level( $index );



    $controller->add_move_handler(
        sub { 
            my $event = shift;
            $camera->move( $event );
            $state->update();
        }
    );

    $controller->add_move_handler(
            sub{
            $_->move() foreach @{ $level->prepared_zombies() };

            }

            );

    $controller->add_show_handler(
            sub {
            $level->draw();
            $camera->update_view( $level->surface() );
            }
            );

    $controller->run();

    return $state->level_index();

}


1;

=pod 

=head1 NAME

ZT - Game initializer 

=head1 METHOD

=head2 start

ZT::start();

Running the code.

=cut 
