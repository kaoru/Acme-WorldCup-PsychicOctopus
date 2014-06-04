package Acme::WorldCup::PsychicOctopus;

use strict;
use warnings;
use feature 'say';

use List::Util qw(min max);

use parent 'Exporter';

our @EXPORT = qw(predict_match_result);

sub predict_match_result {
    my %input = @_;

    my @teams = @{ $input{'teams'} };

    my %scores;
    for my $team (@teams) {
        $scores{$team} = score_team($team);
    }

    normalize_scores(\%scores);

    show_winner(\%scores);
}

sub score_team {
    my $team = shift;

    my $score = 0;
    for my $char (split //, $team) {
        $score++ if $char =~ m/[aeiou]/imsx;
    }

    return $score;
}

sub normalize_scores {
    my $scores = shift;

    my $min = min values %$scores;

    my $min_score_allowed = int rand 2;

    my $diff = $min - $min_score_allowed;

    for my $score (values %$scores) {
        $score -= $diff;
    }

    return;
}

sub show_winner {
    my $scores = shift;

    my @out_teams;
    my @out_scores;
    for my $team (sort { $scores->{$b} <=> $scores->{$a} } keys %$scores) {
        push @out_teams, $team;
        push @out_scores, $scores->{$team};
    }

    say sprintf("%s -> %s",
        join(" - ", @out_teams),
        join(" - ", @out_scores),
    );
}

1;

__END__

=pod

=head1 NAME

Acme::WorldCup::PsychicOctopus - Predict the winner for each match of the World Cup

=head1 DESCRIPTION

At the Nestoria office in London we're betting on the result of each match in
the World Cup. I plan to use Perl to increase my chances of winning the pool!

=head1 SYNOPSIS

    use Acme::WorldCup::PsychicOctopus;

    predict_match_result(
        teams => [ "Argentina", "Iran" ],
        time  => "2014-06-21 13:00",
        city  => "Belo Horizonte",
    );

The C<predict_match_result> function prints its prediction to STDOUT in the format:

    Argentina - Italy -> 3 - 1

=head1 AUTHOR

Alex Balhatchet, C<alex@lokku.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2014 Lokku Ltd <alex@lokku.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16 or,
at your option, any later version of Perl 5 you may have available.

=cut
