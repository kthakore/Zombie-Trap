package ZT::State;
use Modern::Perl;
use ZT::Util;
use Carp;
use Data::Dumper;

sub new {
    my $self =  bless {}, $_[0];

    my $level_glob = $ZT::Util::data_dir."*.yaml";
    my @levels = glob $level_glob;
    $self->{levels} = \@levels;

    $self->{game} = { stage => 'menu', score => 0, player => '', current_level => -1 };
    my $time = localtime; 
    $self->{level} = { 
                        townsfolk => 0, #Update with first level_update 
                        zombies => 0, 
                        town => 100,  #Deafult town strenth
                        start_time => $time, 
                        time => $time
                     };

    return $self;
}

sub game :lvalue {

    $_[0]->{game}

}

sub level :lvalue {

    $_[0]->{level}

}

sub next_level {

  my $level_no = $_[0]->{game}->{current_level} + 1;
 
  $_[0]->{game}->{current_level} = $level_no; 
  return $_[0]->{levels}->[$level_no]; 

}

sub is_level_done {
    my( $self) = @_;

  if(  $self->level()->{zombies} <= 0 )
  {
      $self->{game}->{stage} = 'lost';
  }
  elsif ( $self->level()->{town} <= 0 )
  {
      $self->{game}->{state} = $self->next_level();

  }

}

sub game_update {
    my ($self) = @_;

    #Check if level is done 
    if( $self->is_level_done() )
     {
        
     }

    #Calculate Score of level 

    #Go to next level 

    #End game if no more zombies! 
}

sub level_update {
    my ($self, @args) = @_;

    if( $#args >= 0 )
    {
        my $settings = {@args};

        foreach( keys %$settings )
        {
            $self->{level}->{$_} = $settings->{$_};
        }
    }

    my $time = localtime;
    $self->{time} = $time; 
     
}

1;
