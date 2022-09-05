#!/bin/bash
# ------------------------------------------------------------------------------
# Script name:  plot_current_flow.sh
#
# Description:  Script to plot current flow model for tDCS study
#
# Author:       Caroline Nettekoven, 2022
#
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------

WORKDIR=/Users/CN/Documents/Projects/Joystick_TDCS/

fsleyes \
${WORKDIR}/current_flow_modelling/W3T_2016_100_003/niftis/struct.anat/T1_biascorr_brain.nii.gz \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E.nii.gz \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E.nii.gz &


# Resample from 2mm space to 1mm space
flirt -in brain_4mm.nii.gz -ref brain_2mm.nii.gz -out brain_2mm_new.nii.gz
-nosearch -applyisoxfm 2

# Warp current flow into MNI space
applywarp \
--ref=$FSLDIR/data/standard/MNI152_T1_2mm.nii \
--in=${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E.nii.gz \
--out=${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni.nii.gz \
--warp=${WORKDIR}/current_flow_modelling/W3T_2016_100_003/niftis/struct.anat/T1_to_MNI_nonlin_field.nii.gz

# Show only field within brain
fslmaths \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni.nii.gz \
-mas $FSLDIR/data/standard/MNI152_T1_2mm_brain_mask.nii \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni_brain.nii.gz

# Get range of field within brain
fslstats \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni_brain.nii.gz \
-R -r

# Separate E field into x,y and z direction
fslsplit \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni_brain.nii.gz \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni_brain_dir \
-t

fslstats \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni_brain_dir0000.nii.gz \
-R -r


fslstats \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni_brain_dir0001.nii.gz \
-R -r

fslstats \
${WORKDIR}/current_flow_modelling/cerebelleum_tdcs_TDCS_1_scalar_E_mni_brain_dir0002.nii.gz \
-R -r


# Check MNI registration
fsleyes \
${WORKDIR}/current_flow_modelling/W3T_2016_100_003/niftis/struct.anat/T1_to_MNI_nonlin.nii.gz \
$FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz &