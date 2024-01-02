#!/usr/bin/env bash
source "$(dirname $0)/../test.sh"

test_command ../../mri_convert/mri_convert -dsold 6 6 6 -i T1.mgz -o T1_downsample.mgz && AntsN4BiasFieldCorrectionFs -i T1_downsample.mgz -o T1.out.mgz

# FIX ME - this exception for ubuntu18 should not ne necessary ?

# The tests for mri_ca_label and AntsN4BiasFieldCorrectionFs were the only failures on
# MacOS 10.12 (Monterey) using reference testdata files with the .clang12 TESTDATA_SUFFIX
# - created for running tests on  MacOS10.15 (Catalina).  Given this and that MacOS 10.12
# uses clang13 (instead of clang12), then just directly amend the ifdef for each of these
# tests to look for newly generated reference files on MacOS 10.12 with .clang13 suffix
# So as of this writing TESTDATA_SUFFIX not defined for MacOS 12 and hardcode .clang13 below.
if [ "$host_os" == "macos12" ]; then
   compare_vol --thresh 0.00042725 T1.ref.clang13.mgz T1.out.mgz
elif [ "$host_os" == "ubuntu18" ]; then
   compare_vol T1.ref.gcc8.mgz T1.out.mgz
elif [[ "$TESTDATA_SUFFIX" != "" ]] && [[ "$host_os" == "ubuntu20" ]] || [[ "$host_os" == "ubuntu22" ]] || [[ "$host_os" == "centos8" ]] || [[ "$host_os" == "centos9" ]] || [[ "$host_os" == "macos10" ]]; then
   compare_vol --thresh 0.00042725 T1.ref${TESTDATA_SUFFIX}.mgz T1.out.mgz
else
   compare_vol T1.ref.mgz T1.out.mgz
fi

