#!/usr/bin/env perl
#From Line 4 to Line 33 is a boiler plate. The actual transform generation starts from Line 34
#Please fill in your paths correctly staring from Line 34 
use strict;
use warnings FATAL => qw(uninitialized);
use Carp qw(cluck confess carp croak);
our $DEF_WARN=$SIG{__WARN__};
our $DEF_DIE=$SIG{__DIE__};
#$SIG{__WARN__} = sub { cluck "Undef value: @_" if $_[0] =~ /undefined|uninitialized/;&{$DEF_WARN}(@_) };
$SIG{__WARN__} = sub {
    cluck "Undef value: @_" if $_[0] =~ /undefined|uninitialized/;
    if(defined $DEF_WARN) { &{$DEF_WARN}(@_)}
  };

BEGIN {
    # we could import radish_perl_lib direct to an array, however that complicates the if def checking.
    my @env_vars=qw(RADISH_PERL_LIB BIGGUS_DISKUS WORKSTATION_DATA WORKSTATION_HOME);
    my @errors;
    use Env @env_vars;
    foreach (@env_vars ) {
        push(@errors,"ENV missing: $_") if (! defined(eval("\$$_")) );
    }
    die "Setup incomplete:\n\t".join("\n\t",@errors)."\n  quitting.\n" if @errors;
}
use lib split(':',$RADISH_PERL_LIB);
use civm_simple_util qw(activity_log printd $debug_val);
# On the fence about including pipe utils every time
use pipeline_utilities;
# pipeline_utilities uses GOODEXIT and BADEXIT, but it doesnt choose for you which you want.
$GOODEXIT = 0;
$BADEXIT  = 1;
# END BOILER PLATE
#the working directory
my $output_dir= "R:/";
#the MR data
my $fixed= "R:/19.gaj.43/example/Non-Aligned-Data/nhdr/exampleNLSAM_dwi.nhdr";
#the LS data
my $moving="${output_dir}/190108-5_1_NeuN-initialized.nhdr";
my $ants="K:/workstation/home/ants_2020_03_25/antsRegistration.exe";

my $prefix2='/affine';
   my $stage1=${ants}." -d 3 -o [${output_dir}${prefix2},${output_dir}${prefix2}+.nii.gz] 
   --metric MI[${fixed},${moving},1,32,Regular,0.3] 
   --convergence 100 
   --smoothing-sigmas 2 
   --shrink-factors 8 
   --transform Affine[0.1] --verbose ";#| tee ${output_dir}".'\Pipe1Affine01.txt';

   $moving="${output_dir}${prefix2}+.nii.gz";
my $prefix3='/bspline_syn';
   my $stage2=$ants." -d 3 
   -o [${output_dir}${prefix3},${output_dir}${prefix3}+.nii.gz] 
   --transform BSplineSyN[0.1,26,0,3] 
   --metric CC[${fixed},${moving},1,4] 
   --convergence 1000x1000x1000x1000 
   --smoothing-sigmas 3x2x1x0 
   --shrink-factors 10x7x4x2
   --verbose";# | tee ${output_dir}".'\pipe1bspline01.txt'";

   $moving="${output_dir}${prefix3}+.nii.gz";
my $prefix4='/syn_last_Mattes';
   my $stage3=$ants." -d 3 
   -o [${output_dir}${prefix4},${output_dir}${prefix4}+.nii.gz] 
   --transform SyN[0.1,3,0] 
   --metric Mattes[${fixed},${moving},1,32,Regular,0.3] 
   --convergence 1000x1000x1000x1000 
   --smoothing-sigmas 0x0x0x0 
   --shrink-factors 10x7x4x2 
   --verbose";# | tee ${output_dir}.'\pipe1syn01.txt'";
   
$stage1 =~ s/\n//g;
$stage2 =~ s/\n//g;
$stage3 =~ s/\n//g;
my @command=($stage1,$stage2,$stage3);
#execute_indep_forks(1,'pipe3',@command);
#execute(1,'stage1 is running',$stage1);
#execute(1,'stage2 is running',$stage2);
# execute(1,'stage3 is running',$stage3);
for (@command){execute(1,'stage1 is running',$_);}
