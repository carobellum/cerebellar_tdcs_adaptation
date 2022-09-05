source('~/Documents/Projects/Joystick_TDCS/tdcs_manuscript/code/cerebellar_tdcs_adaptation/tdcs_get_behav_data.R')


# No baseline difference in error between sessions ( 1 vs 2, real vs sham) before turning on stimulation (block 1) ----
# Stimulation is given from the second baseline block  (Trial 41-80) until rotation block 50 (rotation < 50)

modelRIM.baseline         = lmer(Baseline ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Stimulation      = lmer(Baseline ~  Stimulation + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session          = lmer(Baseline ~  Session + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Session)
anova(modelRIM.baseline, modelRIM.Stimulation)

# No baseline difference in error between sessions ( real vs sham) after turning on stimulation (block 2) ----

modelRIM.baseline         = lmer(BaselineStimON ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Stimulation      = lmer(BaselineStimON ~  Stimulation + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session          = lmer(BaselineStimON ~  Session + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Stimulation)

# Participants adapt until the end of the experiment ----
column_number <- which(names(ba)=="error")
x <- aggregate(ba[ba$rotation=="80" & ba$trial<9,column_number], list(ba[ba$rotation=="80"& ba$trial<9,]$sub), mean, na.rm=TRUE)
y <- aggregate(ba[ba$rotation=="80"& ba$trial>32,column_number], list(ba[ba$rotation=="80"& ba$trial>32,]$sub), mean, na.rm=TRUE)

ttest <- NA
ttest <- t.test(x$x, y$x,
                alternative = c("two.sided", "less", "greater"),
                mu = 0, paired = TRUE,
                conf.level = 0.95)
if (ttest$p.value<0.05) {
  msg2 <- sprintf("SIGNIFICANT difference at p= %.3f, etimate=%s ", round(ttest$p.value,2), round(ttest$estimate,2) )
} else {
  msg2 <- sprintf("NO significant difference at p= %.3f, etimate= %s ",  round(ttest$p.value,2), round(ttest$estimate,2) )}
print(msg2) 
ttest

mean(x$x-y$x)
sd(x$x-y$x)

# Participants performed better in session 2 than session 1 ----
modelRIM.baseline                     = lmer(Error ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session                      = lmer(Error ~  Session + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Session)

# Participants performed better in session 2 than session 1 during stimulation----
modelRIM.baseline                     = lmer(Error_StimON ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session                      = lmer(Error_StimON ~  Session + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Session)

# Participants did not adapt better in real condition ----

modelRIM.baseline                     = lmer(Error ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Stimulation                  = lmer(Error ~  Stimulation + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session                      = lmer(Error ~  Session + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.SessionStimulation           = lmer(Error ~  Session + Stimulation + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Stimulation)
anova(modelRIM.Session, modelRIM.SessionStimulation) # controlling for factor of session

# Participants did not adapt better in real condition during online stimulation ----
modelRIM.baseline                     = lmer(Error_StimON ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Stimulation                  = lmer(Error_StimON ~  Stimulation + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session                      = lmer(Error_StimON ~  Session + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.SessionStimulation           = lmer(Error_StimON ~  Session + Stimulation + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Stimulation)
anova(modelRIM.Session, modelRIM.SessionStimulation) # controlling for factor of session

# Participants did not adapt better in real condition in first session  ----
modelGLM.Stimulation = lm(Error ~ Stimulation, data=tdcs[tdcs$Session==1,])
summary(modelGLM.Stimulation)

# Trend towards better adaptation in real condition that is explained by baseline differences ----

# Construct subset of data excluding participants who reported that they noticed a perturbation
SubjectsThatNoticedPerturbation = c('F02','F05','F06','F09','F13','F14','F16','F18','M01','M03','M04','M05','M07','M08','M11')
ExcludeRows <- vector()
for (i in SubjectsThatNoticedPerturbation)
  ExcludeRows <- c(ExcludeRows, which(tdcs$Subject == i))

tdcs_unaware <- tdcs[-c(ExcludeRows), ]

modelRIM.Session                      = lmer(Error ~  Session + (1 | Subject), data=tdcs_unaware, REML = FALSE)
modelRIM.SessionStimulation           = lmer(Error ~  Session + Stimulation + (1 | Subject), data=tdcs_unaware, REML = FALSE)

anova(modelRIM.Session, modelRIM.SessionStimulation) # controlling for factor of session

# Baseline difference explains difference between conditions
modelRIM.baseline         = lmer(Baseline ~  (1 | Subject), data=tdcs_unaware, REML = FALSE)
modelRIM.Stimulation      = lmer(Baseline ~  Stimulation + (1 | Subject), data=tdcs_unaware, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Stimulation)


# No difference in retention ----
modelRIM.baseline                     = lmer(Retention ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Stimulation                  = lmer(Retention ~  Stimulation + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session                      = lmer(Retention ~  Session + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.SessionStimulation           = lmer(Retention ~  Session + Stimulation + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Stimulation)
anova(modelRIM.Session, modelRIM.SessionStimulation) # controlling for factor of session


# No difference in retention during online stimulation----
modelRIM.baseline                     = lmer(Retention_StimON ~  (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Stimulation                  = lmer(Retention_StimON ~  Stimulation + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.Session                      = lmer(Retention_StimON ~  Session + (1 | Subject), data=tdcs, REML = FALSE)
modelRIM.SessionStimulation           = lmer(Retention_StimON ~  Session + Stimulation + (1 | Subject), data=tdcs, REML = FALSE)

anova(modelRIM.baseline, modelRIM.Stimulation)
anova(modelRIM.Session, modelRIM.SessionStimulation) # controlling for factor of session


