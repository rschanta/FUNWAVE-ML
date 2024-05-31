










!-------------------------------------------------------------------------------------
!     OUTPUT
!           - Calculate statistics to display (Statistics)
!           - Outputs timesteps to individual files (Preview)
!-------------------------------------------------------------------------------------
SUBROUTINE OUTPUT
    USE GLOBAL
    IMPLICIT NONE

      SCREEN_COUNT=SCREEN_COUNT+DT

      ! Calculate statistics to display
      IF(SCREEN_COUNT>=SCREEN_INTV)THEN
            SCREEN_COUNT=SCREEN_COUNT-SCREEN_INTV
            CALL STATISTICS
      ENDIF

      ! Output individual eta_XXXXX files
      IF(TIME>=PLOT_START_TIME)THEN
            PLOT_COUNT=PLOT_COUNT+DT
            IF(PLOT_COUNT>=PLOT_INTV)THEN
                  PLOT_COUNT=PLOT_COUNT-PLOT_INTV
                  CALL PREVIEW
            ENDIF
      ENDIF 
END SUBROUTINE OUTPUT

!-------------------------------------------------------------------------------------
!     READ_INPUT 
!           - Read in all data from input.txt file
!-------------------------------------------------------------------------------------

SUBROUTINE READ_INPUT
      ! Import necessary modules
      USE GLOBAL
      USE INPUT_READ

      !! Variable declarations
      IMPLICIT NONE
      CHARACTER(LEN=80) FILE_NAME
      CHARACTER(LEN=80) MKFOLDER
      INTEGER::LINE
      INTEGER :: ierr
      INTEGER :: I_comp
      LOGICAL :: INPUT_PHASE = .FALSE.
      ! ìnput.txt` FILE NAME
            CHARACTER(LEN=80)::INPUT_NAME=''
      ! RESULT_FOLDER
            CHARACTER(LEN=80)::FDIR=' '

      ! Set up MPI if needed
            CALL MPI_COMM_SIZE (MPI_COMM_WORLD, nprocs, ier)  
            CALL MPI_COMM_RANK (MPI_COMM_WORLD, myid, ier)

      ! Set up RESULT_FOLDER, time_dt.out, and LOG.txt file
      FDIR=TRIM(RESULT_FOLDER)
      OPEN(10000,FILE='time_dt.out',STATUS='UNKNOWN')
      OPEN(3,FILE='LOG.txt')   

      ! Get name of `input.txt` file
      CALL GETARG(1,INPUT_NAME) 
            ! defaults to `input.txt` if not given
            if (INPUT_NAME .eq. '') Then
                  FILE_NAME='input.txt'
            ! uses argument name otherwise
            Else
                  FILE_NAME=INPUT_NAME
            endif
      INPUT_FILE_NAME=FILE_NAME

      !@! START LOG FILE
      CALL READ_STRING(TITLE,FILE_NAME,'TITLE',ierr)
      ! Default to 'TEST RUN' if no name given
      IF(ierr==1)THEN
        TITLE='---TEST RUN---'
      ENDIF
      ! Start up log file (parallel)
            if (myid.eq.0) WRITE(3,*)'-------------- LOG FILE -----------------'
            if (myid.eq.0) WRITE(3,*)TITLE
            if (myid.eq.0) WRITE(3,*)' --------------input start --------------'
      ! Start up log file (not parallel)

      !@! Parallel Info
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- PARALLEL -----------------'    
            ! Print PX and PY Parallel Information
                  ! PX Information
                  CALL READ_INTEGER(PX,FILE_NAME,'PX',ierr)
                  IF(ierr == 1) THEN
                        PX = 1
                        if (myid.eq.0)write(*,*) 'No PX sepecified ', 'use PX=1'
                        if (myid.eq.0)WRITE(3,'(A20,A20)')'No PX sepecified ', 'use PX=1'
                  ENDIF
                  ! PY Information
                  CALL READ_INTEGER(PY,FILE_NAME,'PY',ierr)  
                  IF(ierr == 1) THEN
                        PY = 1
                        if (myid.eq.0)write(*,*) 'No PY sepecified ', 'use PY=1'
                        if (myid.eq.0)WRITE(3,'(A20,A20)')'No PY sepecified ', 'use PY=1'
                  ENDIF
                  ! Print PX and PY info to log
                  if (myid.eq.0) WRITE(3,'(A7,I3,A7,I3)') 'PX   =',PX,'PY   =', PY

      !@! Grid Info
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- GRID INFO -----------------'

            ! Get and check Mglob dimension
            CALL READ_INTEGER(Mglob,FILE_NAME,'Mglob',ierr)
            IF(ierr==1)THEN
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40,A40)')'Mglob:', 'NOT DEFINED, STOP'
                              WRITE(3,'(A40,A40)')'Mglob:', 'NOT DEFINED, STOP'
                        endif
                        call MPI_FINALIZE ( ier )
                        STOP
            ENDIF

            ! Get and check Nglob dimension
            CALL READ_INTEGER(Nglob,FILE_NAME,'Nglob',ierr)
            IF(ierr==1)THEN
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40,A40)')'Nglob:', 'NOT DEFINED, STOP'
                              WRITE(3,'(A40,A40)')'Nglob:', 'NOT DEFINED, STOP'
                        endif
                        call MPI_FINALIZE ( ier )
                        STOP
            ENDIF

            ! Print grid dimensions
                  if (myid.eq.0) WRITE(3,'(A7,I8,A7,I8)') 'Mglob=',Mglob,'Nglob=', Nglob

            ! Cartesian Settings
                  CALL READ_FLOAT(DX,FILE_NAME,'DX',ierr)
                  ! Error message: Did you intend to use Spherical?
                  IF(ierr==1)THEN
                        PRINT *,"Did you intend to use Spherical Coordinates?"
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40,A40)')'DX:', 'NOT DEFINED, STOP'
                                    WRITE(3,'(A40,A40)')'DX:', 'NOT DEFINED, STOP'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF
                  CALL READ_FLOAT(DY,FILE_NAME,'DY',ierr)

                  ! Error message: Undefined DX and DY
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40,A40)')'DY:', 'NOT DEFINED, STOP'
                                    WRITE(3,'(A40,A40)')'DY:', 'NOT DEFINED, STOP'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF
                  
                  ! Print DX and DY out
                        if (myid.eq.0) WRITE(3,'(A4,F12.2,A4,F12.2)')'DX=',DX,'DY=',DY

            ! Spherical Settings

      !@! DEPTH INFO
            CALL READ_STRING(DEPTH_TYPE,FILE_NAME,'DEPTH_TYPE',ierr)
            ! Error handling for DEPTH_TYPE > default to flat                     
            IF(ierr==1)THEN
                  DEPTH_TYPE = 'FLAT'
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'You dont specify DEPTH_TYPE, use FLAT.'
                              WRITE(3,'(A40)')'You dont specify DEPTH_TYPE, use FLAT.'
                        endif
            ENDIF

            ! Write out DEPTH_TYPE
                  if (myid.eq.0) WRITE(3,'(A12,A50)')'DEPTH_TYPE:', DEPTH_TYPE

            ! Write out DEPTH_FILE if given
            IF(DEPTH_TYPE(1:3)=='DAT')THEN
                  CALL READ_STRING(DEPTH_FILE,FILE_NAME,'DEPTH_FILE',ierr)
                        if (myid.eq.0) WRITE(3,'(A12,A50)')'DEPTH_FILE:', DEPTH_FILE
            ENDIF  

            ! DEPTH_TYPE= FLAT settings
            IF(DEPTH_TYPE(1:3)=='FLA')THEN
                  CALL READ_FLOAT(DEPTH_FLAT,FILE_NAME,'DEPTH_FLAT',ierr) 
                  ! Error handling for DEPTH_TYPE=FLAT
                        IF(ierr==1)THEN
                              DEPTH_FLAT = 10.0_SP
                                    if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'You dont specify DEPTH_FLAT, use 10 m.'
                                    WRITE(3,'(A40)')'You dont specify DEPTH_FLAT, use 10 m.'
                                    endif
                        ENDIF      
                  ! Write out DEPTH_FLAT
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'DEPTH_FLAT=', DEPTH_FLAT  
            ENDIF 

            ! DEPTH_TYPE = SLOPE
            IF(DEPTH_TYPE(1:3)=='SLO')THEN
                  CALL READ_FLOAT(DEPTH_FLAT,FILE_NAME,'DEPTH_FLAT',ierr) 
                  ! Error handling for DEPTH_TYPE=SLOPE DEPTH_FLAT variable
                  IF(ierr==1)THEN
                        DEPTH_FLAT = 10.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'You dont specify DEPTH_FLAT, use 10 m.'
                                    WRITE(3,'(A40)')'You dont specify DEPTH_FLAT, use 10 m.'
                              endif
                  ENDIF

                  CALL READ_FLOAT(SLP,FILE_NAME,'SLP',ierr) 
                  ! Error handling for DEPTH_TYPE=SLOPE SLP variable
                  IF(ierr==1)THEN
                        SLP = 0.1_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'You dont specify SLP, use 0.1'
                                    WRITE(3,'(A40)')'You dont specify SLP, use 0.1'
                              endif
                  ENDIF 
                  CALL READ_FLOAT(Xslp,FILE_NAME,'Xslp',ierr) 

                  ! Error handling for DEPTH_TYPE=SLOPE Xslp variable
                  IF(ierr==1)THEN
                        Xslp = 0.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'You dont specify Xslp, use 0.0'
                                    WRITE(3,'(A40)')'You dont specify Xslp, use 0.0'
                              endif
                  ENDIF 

                  ! Write out DEPTH_FLAT = SLP parameters
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'DEPTH_FLAT=', DEPTH_FLAT 
                        if (myid.eq.0) WRITE(3,'(A5,F12.2)')'SLP=', SLP
                        if (myid.eq.0) WRITE(3,'(A6,F12.2)')'Xslp=', Xslp  
            ENDIF  

      !@! DEPTH CORRECTION
            CALL READ_LOGICAL(BATHY_CORRECTION,FILE_NAME,'BATHY_CORRECTION',ierr)
            IF(ierr == 1)THEN
                  BATHY_CORRECTION = .FALSE. 
            ENDIF
            IF(BATHY_CORRECTION)THEN
                        if (myid.eq.0)then
                              WRITE(3,'(A40)')'Bathymetry is corrected !'
                              WRITE(*,'(A40)')'Bathymetry is corrected !'
                        endif
            ENDIF

      !@! TIME INFORMATION
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- TIME INFO -----------------'

            CALL READ_FLOAT(TOTAL_TIME,FILE_NAME,'TOTAL_TIME',ierr)
            ! Error handling for TOTAL_TIME variable
            IF(ierr==1)THEN
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40,A40)')'TOTAL_TIME:', 'NOT FOUND, STOP'
                              WRITE(3,'(A40,A40)')'TOTAL_TIME:', 'NOT FOUND, STOP'
                        endif
                        call MPI_FINALIZE ( ier )
                  STOP
            ENDIF

            CALL READ_FLOAT(PLOT_START_TIME,FILE_NAME,'PLOT_START_TIME',ierr)
            ! Error handling for PLOT_START_TIME variable
            IF(ierr==1)THEN
                  PLOT_START_TIME = 0.0
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'PLOT_START_TIME Default:  0.0 s'
                              WRITE(3,'(A40)')'PLOT_START_TIME Default:  0.0 s'
                        endif
            ENDIF

            CALL READ_FLOAT(PLOT_INTV,FILE_NAME,'PLOT_INTV',ierr)
            ! Error handling for PLOT_INTV variable
            IF(ierr==1)THEN
                  PLOT_INTV = 1.0
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'PLOT_INTV Default:  1.0 s'
                              WRITE(3,'(A40)')'PLOT_INTV Default:  1.0 s'
                        endif
            ENDIF

            CALL READ_FLOAT(PLOT_INTV_STATION,FILE_NAME,'PLOT_INTV_STATION',ierr)
            ! Error handling for PLOT_INTV_STATION variable
            IF(ierr==1)THEN
                  PLOT_INTV_STATION = 1.0
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'PLOT_INTV_STATION Default:  1.0 s'
                              WRITE(3,'(A40)')'PLOT_INTV_STATION Default:  1.0 s'
                        endif
            ENDIF

      
            CALL READ_INTEGER(StationOutputBuffer,FILE_NAME,'StationOutputBuffer',ierr)
            ! Error handling for StationOutputBuffer variable
            IF(ierr==1)THEN
                  StationOutputBuffer = 1000
                        if (myid.eq.0) THEN
                              WRITE(*,'(A80)')'StationOutputBuffer not specified, use default:1000'
                              WRITE(3,'(A80)')'StationOutputBuffer not specified, use default:1000'
                        endif
            ENDIF

            CALL READ_FLOAT(SCREEN_INTV,FILE_NAME,'SCREEN_INTV',ierr)
            ! Error handling for SCREEN_INTV variable
            IF(ierr==1)THEN
                  SCREEN_INTV = 1.0
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'SCREEN_INTV Default:  1.0 s'
                              WRITE(3,'(A40)')'SCREEN_INTV Default:  1.0 s'
                        endif
            ENDIF

            ! Write out time information
                  if (myid.eq.0) WRITE(3,'(A12,F12.2)')'TOTAL_TIME=', TOTAL_TIME
                  if (myid.eq.0) WRITE(3,'(A12,F12.2)')'PLOT_INTV= ', PLOT_INTV
                  if (myid.eq.0) WRITE(3,'(A13,F12.2)')'SCREEN_INTV=', SCREEN_INTV


      !@! WAVEMAKER INFORMATION
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- WAVEMAKER -----------------'

            ! Get Wavemaker type
            CALL READ_STRING(WaveMaker,FILE_NAME,'WAVEMAKER',ierr)
            ! Error handling for no wavemaker
            IF(ierr==1)THEN
                  WaveMaker = 'nothing'
                        if (myid.eq.0) THEN
                        WRITE(*,'(A40)')'No WaveMaker'
                        WRITE(3,'(A40)')'No WaveMaker'
                        endif
            ENDIF

            ! Print out wavemaker type
                  if (myid.eq.0) WRITE(3,'(A11,A50)')'WAVEMAKER:', WAVEMAKER
            
            ! LEF_SOL Wavemaker type
            IF(WaveMaker(1:7)=='LEF_SOL')THEN
                  CALL READ_FLOAT(AMP_SOLI,FILE_NAME,'AMP',ierr)
                  ! Error handling for no AMP_SOLI variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                              WRITE(*,'(A60)')'AMP_SOLI NOT FOUND, specify AMP in input.txt'
                              WRITE(3,'(A60)')'AMP_SOLI NOT FOUND, specify AMP in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                              STOP
                  ENDIF

                  CALL READ_FLOAT(DEP_SOLI,FILE_NAME,'DEP',ierr)
                  ! Error handling for no DEP variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'DEP_SOLI NOT FOUND, specify DEP in input.txt'
                                    WRITE(3,'(A60)')'DEP_SOLI NOT FOUND, specify DEP in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF


                  CALL READ_FLOAT(LAG_SOLI,FILE_NAME,'LAGTIME',ierr)
                  ! Error handling for lag time
                  IF(ierr==1)THEN
                        LAG_SOLI = 0.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'LAGTIME Default:  0.0'
                                    WRITE(3,'(A40)')'LAGTIME Default:  0.0'
                              endif
                  ENDIF

                  ! Print out LEF_SOL information
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'AMP_SOLI=', AMP_SOLI
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'DEP_SOLI=', DEP_SOLI
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'LAG_SOLI=', LAG_SOLI
            ENDIF

            ! WK_TIME wavemaker type
            IF(WaveMaker(1:7)=='WK_TIME')THEN
                  CALL READ_INTEGER(NumWaveComp,FILE_NAME,'NumWaveComp',ierr)
                  ! Error handling for no NumWaveComp variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'NumWaveComp NOT FOUND, specify NumWaveComp in input.txt'
                                    WRITE(3,'(A80)')'NumWaveComp NOT FOUND, specify NumWaveComp in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(PeakPeriod,FILE_NAME,'PeakPeriod',ierr)
                  ! Error handling for no PeakPeriod variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'PeakPeriod NOT FOUND, specify PeakPeriod in input.txt'
                                    WRITE(3,'(A80)')'PeakPeriod NOT FOUND, specify PeakPeriod in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                 CALL READ_STRING(WaveCompFile,FILE_NAME,'WaveCompFile',ierr)
                  ! Error handling for no WaveCompFile variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'WaveCompFile NOT FOUND, specify WaveCompFile in input.txt'
                                    WRITE(3,'(A80)')'WaveCompFile NOT FOUND, specify WaveCompFile in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(Xc_WK,FILE_NAME,'Xc_WK',ierr)
                  ! Error handling for no Xc_WK variable
                  IF(ierr==1)THEN
                        if (myid.eq.0) THEN
                              WRITE(*,'(A80)')'Xc_WK NOT FOUND, specify Xc_WK in input.txt'
                              WRITE(3,'(A80)')'Xc_WK NOT FOUND, specify Xc_WK in input.txt'
                        endif
                        call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(Yc_WK,FILE_NAME,'Yc_WK',ierr)
                  ! Error handling for no Yc_WK variable
                  IF(ierr==1)THEN
                        Yc_WK = ZERO
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A50)')'Yc_WK defalt: 0.0'
                                    WRITE(3,'(A50)')'Yc_WK defalt: 0.0'
                              endif
                  ENDIF

                  CALL READ_FLOAT(DEP_WK,FILE_NAME,'DEP_WK',ierr)
                  ! Error handling for no DEP_WK variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'DEP_WK NOT FOUND, specify DEP_WK in input.txt'
                                    WRITE(3,'(A80)')'DEP_WK NOT FOUND, specify DEP_WK in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(Time_ramp,FILE_NAME,'Time_ramp',ierr)
                  ! Error handling for no Time_ramp variable
                  IF(ierr==1)THEN
                        Time_ramp = 0.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Time_ramp Default:  0.0'
                                    WRITE(3,'(A40)')'Time_ramp Default:  0.0'
                              endif
                  ENDIF

                  CALL READ_FLOAT(Delta_WK,FILE_NAME,'Delta_WK',ierr)
                  ! Error handling for no Delta_WK variable
                  IF(ierr==1)THEN
                        Delta_WK = 0.5_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Delta_WK Default:  0.5'
                                    WRITE(3,'(A40)')'Delta_WK Default:  0.5'
                              endif
                  ENDIF


                  CALL READ_FLOAT(Ywidth_WK,FILE_NAME,'Ywidth_WK',ierr)
                  ! Error handling for no Ywidth_WK variable
                  IF(ierr==1)THEN
                        Ywidth_WK = LARGE
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Ywidth_WK Default:  LARGE'
                                    WRITE(3,'(A40)')'Ywidth_WK Default:  LARGE'
                              endif
                  ENDIF
                  ! Print out WK_Time 
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Xc_WK   =', Xc_WK
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Yc_WK   =', Yc_WK
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'DEP_WK  =', DEP_WK
                        if (myid.eq.0) WRITE(3,'(A11,F12.2)')'Time_ramp=', Time_ramp
                        if (myid.eq.0) WRITE(3,'(A11,F12.2)')'Delta_WK=', Delta_WK
                        if (myid.eq.0) WRITE(3,'(A11,F12.2)')'Ywidth_WK=', Ywidth_WK

            ENDIF  

            ! INI_SOL wavemaker type
            IF(WaveMaker(1:7)=='INI_SOL')THEN
                  ! Set direction of solitary wave
                  CALL READ_LOGICAL(SolitaryPositiveDirection,FILE_NAME,  &
                         'SolitaryPositiveDirection',ierr)
                  IF(ierr==1)THEN
                        SolitaryPositiveDirection = .TRUE.
                  ENDIF

                  ! Print direction of wave
                  IF(SolitaryPositiveDirection) THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'Solitary wave propagate in + X direction'
                                    WRITE(3,'(A60)')'Solitary wave propagate in + X direction'
                              endif
                              ELSE
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'Solitary wave propagate in - X direction'
                                    WRITE(3,'(A60)')'Solitary wave propagate in - X direction'
                              endif
                  ENDIF

                  CALL READ_FLOAT(AMP_SOLI,FILE_NAME,'AMP',ierr)
                  ! Error handling for no AMP variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'AMP_SOLI NOT FOUND, specify AMP in input.txt'
                                    WRITE(3,'(A60)')'AMP_SOLI NOT FOUND, specify AMP in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(DEP_SOLI,FILE_NAME,'DEP',ierr)
                  ! Error handling for no DEP variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'DEP_SOLI NOT FOUND, specify DEP in input.txt'
                                    WRITE(3,'(A60)')'DEP_SOLI NOT FOUND, specify DEP in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                              STOP
                  ENDIF

                  CALL READ_FLOAT(XWAVEMAKER,FILE_NAME,'XWAVEMAKER',ierr)
                  ! Error handling for no DEP variable
                        IF(ierr==1)THEN
                                    if (myid.eq.0) THEN
                                          WRITE(*,'(A80)')'XWAVEMAKER NOT FOUND, specify XWAVEMAKER in input.txt'
                                          WRITE(3,'(A80)')'XWAVEMAKER NOT FOUND, specify XWAVEMAKER in input.txt'
                                    endif
                                    call MPI_FINALIZE ( ier )
                                    STOP
                                    ENDIF

                                    if (myid.eq.0) WRITE(3,'(A10,F12.2)')'AMP_SOLI=', AMP_SOLI
                                    if (myid.eq.0) WRITE(3,'(A10,F12.2)')'DEP_SOLI=', DEP_SOLI
                        ENDIF  ! end initial solitary

            ! N_WAVE Wavemaker type
            IF(WaveMaker(1:6)=='N_WAVE')THEN
                  CALL READ_FLOAT(x1_Nwave,FILE_NAME,'x1_Nwave',ierr)
                  ! Error handling for no x1_Nwave variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'x1_Nwave NOT FOUND, specify x1_Nwave in input.txt'
                                    WRITE(3,'(A80)')'x1_Nwave NOT FOUND, specify x1_Nwave in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(x2_Nwave,FILE_NAME,'x2_Nwave',ierr)
                  ! Error handling for no x2_Nwave variable
                        IF(ierr==1)THEN
                                    if (myid.eq.0) THEN
                                          WRITE(*,'(A80)')'x2_Nwave NOT FOUND, specify x2_Nwave in input.txt'
                                          WRITE(3,'(A80)')'x2_Nwave NOT FOUND, specify x2_Nwave in input.txt'
                                          endif
                                          call MPI_FINALIZE ( ier )
                              STOP
                        ENDIF

                  CALL READ_FLOAT(a0_Nwave,FILE_NAME,'a0_Nwave',ierr)
                  ! Error handling for no a0_Nwave variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'a0_Nwave NOT FOUND, specify a0_Nwave in input.txt'
                                    WRITE(3,'(A80)')'a0_Nwave NOT FOUND, specify a0_Nwave in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(gamma_Nwave,FILE_NAME,'gamma_Nwave',ierr)
                  ! Error handling for no gamma_Nwave variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                              WRITE(*,'(A80)')'gamma_Nwave NOT FOUND, specify gamma_Nwave in input.txt'
                              WRITE(3,'(A80)')'gamma_Nwave NOT FOUND, specify gamma_Nwave in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                              STOP
                  ENDIF

                  CALL READ_FLOAT(dep_Nwave,FILE_NAME,'dep_Nwave',ierr)
                  ! Error handling for no dep_Nwave variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'dep_Nwave NOT FOUND, specify dep_Nwave in input.txt'
                                    WRITE(3,'(A80)')'dep_Nwave NOT FOUND, specify dep_Nwave in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  ! Write out N_wave parameters
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'x1_Nwave=', x1_Nwave
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'x2_Nwave=', x2_Nwave
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'a0_Nwave=', a0_Nwave
                        if (myid.eq.0) WRITE(3,'(A13,F12.2)')'gamma_Nwave=', gamma_Nwave
                        if (myid.eq.0) WRITE(3,'(A11,F12.2)')'dep_Nwave=', dep_Nwave
            ENDIF  

            ! INI_REC Wavemaker type
            IF(WaveMaker(1:7)=='INI_REC')THEN
                  CALL READ_FLOAT(AMP_SOLI,FILE_NAME,'AMP',ierr)
                  ! Error handling for no AMP variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A50)')'AMP NOT FOUND, specify AMP in input.txt'
                                    WRITE(3,'(A50)')'AMP NOT FOUND, specify AMP in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                              STOP
                  ENDIF

                  CALL READ_FLOAT(Xc,FILE_NAME,'Xc',ierr)
                  ! Error handling for no Xc variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Xc NOT FOUND, specify Xc in input.txt'
                                    WRITE(3,'(A40)')'Xc NOT FOUND, specify Xc in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(Yc,FILE_NAME,'Yc',ierr)
                  ! Error handling for no Yc variable
                  IF(ierr==1)THEN
                        Yc = ZERO
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Yc NOT FOUND, specify Yc in input.txt'
                                    WRITE(3,'(A40)')'Yc NOT FOUND, specify Yc in input.txt'
                              endif
                  ENDIF


                  CALL READ_FLOAT(WID,FILE_NAME,'WID',ierr)
                  ! Error handling for no WID variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A50)')'WID NOT FOUND, specify WID in input.txt'
                                    WRITE(3,'(A50)')'WID NOT FOUND, specify WID in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  ! Write out INI_REC parameters
                              if (myid.eq.0) WRITE(3,'(A10,F12.2)')'AMP     =', AMP_SOLI
                              if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Xc      =', Xc
                              if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Yc      =', Yc
                              if (myid.eq.0) WRITE(3,'(A10,F12.2)')'WID     =', WID
                        ENDIF ! endif rectangular hump

        
            ! WK_REG Wavemaker type
            IF(WaveMaker(1:6)=='WK_REG')THEN
                  CALL READ_FLOAT(Xc_WK,FILE_NAME,'Xc_WK',ierr)
                  ! Error handling for no Xc_WK variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'Xc_WK NOT FOUND, specify Xc_WK in input.txt'
                                    WRITE(3,'(A60)')'Xc_WK NOT FOUND, specify Xc_WK in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(Yc_WK,FILE_NAME,'Yc_WK',ierr)
                  ! Error handling for no Yc_WK variable
                  IF(ierr==1)THEN
                        Yc_WK = ZERO
                              if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'Yc_WK defalt: 0.0'
                              WRITE(3,'(A40)')'Yc_WK defalt: 0.0'
                              endif
                  ENDIF


                  CALL READ_FLOAT(Tperiod,FILE_NAME,'Tperiod',ierr)
                  ! Error handling for no Tperiod variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'Tperiod NOT FOUND, specify Tperiod in input.txt'
                                    WRITE(3,'(A60)')'Tperiod NOT FOUND, specify Tperiod in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(AMP_WK,FILE_NAME,'AMP_WK',ierr)
                  ! Error handling for no AMP_WK variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'AMP_WK NOT FOUND, specify AMP_WK in input.txt'
                                    WRITE(3,'(A60)')'AMP_WK NOT FOUND, specify AMP_WK in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(DEP_WK,FILE_NAME,'DEP_WK',ierr)
                  ! Error handling for no DEP_WK variable
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A60)')'DEP_WK NOT FOUND, specify DEP_WK in input.txt'
                                    WRITE(3,'(A60)')'DEP_WK NOT FOUND, specify DEP_WK in input.txt'
                              endif
                              call MPI_FINALIZE ( ier )
                        STOP
                  ENDIF

                  CALL READ_FLOAT(Theta_WK,FILE_NAME,'Theta_WK',ierr)
                  ! Error handling for no Theta_WK variable
                  IF(ierr==1)THEN
                        Theta_WK = 0.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Theta_WK Default:  0.0'
                                    WRITE(3,'(A40)')'Theta_WK Default:  0.0'
                              endif
                  ENDIF

                  CALL READ_FLOAT(Time_ramp,FILE_NAME,'Time_ramp',ierr)
                  ! Error handling for no Time_ramp variable
                  IF(ierr==1)THEN
                        Time_ramp = 0.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Time_ramp Default:  0.0'
                                    WRITE(3,'(A40)')'Time_ramp Default:  0.0'
                              endif
                  ENDIF

                  CALL READ_FLOAT(Delta_WK,FILE_NAME,'Delta_WK',ierr)
                  ! Error handling for no Delta_WK variable
                  IF(ierr==1)THEN
                        Delta_WK = 0.5_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Delta_WK Default:  0.5'
                                    WRITE(3,'(A40)')'Delta_WK Default:  0.5'
                              endif
                  ENDIF

                  CALL READ_FLOAT(Ywidth_WK,FILE_NAME,'Ywidth_WK',ierr)
                  ! Error handling for no Ywidth_WK variable
                  IF(ierr==1)THEN
                        Ywidth_WK = LARGE
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Ywidth_WK Default:  LARGE'
                                    WRITE(3,'(A40)')'Ywidth_WK Default:  LARGE'
                              endif
                  ENDIF

                  ! Write out parameters
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Xc_WK   =', Xc_WK
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Yc_WK   =', Yc_WK
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Tperiod =', Tperiod
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'AMP_WK  =', AMP_WK
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'DEP_WK  =', DEP_WK
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Theta_WK=', Theta_WK
                        if (myid.eq.0) WRITE(3,'(A11,F12.2)')'Time_ramp=', Time_ramp
                        if (myid.eq.0) WRITE(3,'(A11,F12.2)')'Delta_WK=', Delta_WK
                        if (myid.eq.0) WRITE(3,'(A11,F12.2)')'Ywidth_WK=', Ywidth_WK
                        ENDIF  

        
      !@! PERIODIC BC INFORMATION
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- PERIODIC BC -----------------'

            ! Check Cartesian
                  ! south-north periodic boundary condition
                  CALL READ_LOGICAL(PERIODIC,FILE_NAME,'PERIODIC',ierr)
                  IF(ierr==1)THEN
                        PERIODIC = .FALSE.
                  ENDIF
                  ! Write out parameters
                        if (myid.eq.0) WRITE(3,'(A11,L2)')'PERIODIC:', PERIODIC

      !@! SPONGE INFORMATION
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- SPONGE -----------------'

            ! Get the type of sponge
                  CALL READ_LOGICAL(DIFFUSION_SPONGE,FILE_NAME,'DIFFUSION_SPONGE',ierr)
                  IF(ierr==1)THEN
                        DIFFUSION_SPONGE = .FALSE.
                  ENDIF

                  CALL READ_LOGICAL(DIRECT_SPONGE,FILE_NAME,'DIRECT_SPONGE',ierr)
                  IF(ierr==1)THEN
                        DIRECT_SPONGE = .FALSE.
                  ENDIF

                  CALL READ_LOGICAL(FRICTION_SPONGE,FILE_NAME,'FRICTION_SPONGE',ierr)
                  IF(ierr==1)THEN
                        FRICTION_SPONGE = .FALSE.
                  ENDIF

            ! Direct Sponge
                  IF(DIRECT_SPONGE)THEN

                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'DIRECT_SPONGE IS USED'
                                    WRITE(3,'(A40)')'DIRECT_SPONGE IS USED'
                              endif
                  ENDIF

            ! Diffusion Sponge
            IF(DIFFUSION_SPONGE)THEN
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'DIFFUSION_SPONGE IS USED'
                              WRITE(3,'(A40)')'DIFFUSION_SPONGE IS USED'
                        endif
                  ! Csp parameter
                  CALL READ_FLOAT(Csp,FILE_NAME,'Csp',ierr)
                  IF(ierr==1)THEN
                        Csp = 0.1_SP
                              if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'Csp Default:  0.1'
                              WRITE(3,'(A40)')'Csp Default:  0.1'
                              endif
                  ENDIF
                  ! Print out parameters
                        if (myid.eq.0) WRITE(3,'(A22,F12.2)')'DIFFUSION_SPONGE Csp=', Csp
            ENDIF ! end diffusion_sponge

            ! Friction Sponge
            IF(FRICTION_SPONGE)THEN
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'FRICTION_SPONGE IS USED'
                              WRITE(3,'(A40)')'FRICTION_SPONGE IS USED'
                        endif
                        ! Set CDSponge
                        CALL READ_FLOAT(CDsponge,FILE_NAME,'CDsponge',ierr)
                        IF(ierr==1)THEN
                              CDsponge = 5.0_SP
                                    if (myid.eq.0) THEN
                                          WRITE(*,'(A40)')'CDsponge Default:  5.0'
                                          WRITE(3,'(A40)')'CDsponge Default:  5.0'
                                    endif
                        ENDIF

                                    if (myid.eq.0) WRITE(3,'(A26,F12.2)')'FRICTION_SPONGE CDsponge=', CDsponge
            ENDIF  

            ! Common sponge parameters
            IF(DIFFUSION_SPONGE.OR.DIRECT_SPONGE.OR.FRICTION_SPONGE)THEN
                  ! WEST WIDTH
                  CALL READ_FLOAT(Sponge_west_width,FILE_NAME,'Sponge_west_width',ierr)
                        IF(ierr==1)THEN
                              Sponge_west_width = 0.0_SP
                                    if (myid.eq.0) THEN
                                          WRITE(*,'(A40)')'Sponge_west_width Default:  0.0'
                                          WRITE(3,'(A40)')'Sponge_west_width Default:  0.0'
                                    endif
                        ENDIF
                  ! EAST WIDTH
                  CALL READ_FLOAT(Sponge_east_width,FILE_NAME,'Sponge_east_width',ierr)
                        IF(ierr==1)THEN
                              Sponge_east_width = 0.0_SP
                                    if (myid.eq.0) THEN
                                          WRITE(*,'(A40)')'Sponge_east_width Default:  0.0'
                                          WRITE(3,'(A40)')'Sponge_east_width Default:  0.0'
                                    endif
                        ENDIF
                  ! SOUTH WIDTH
                  CALL READ_FLOAT(Sponge_south_width,FILE_NAME,'Sponge_south_width',ierr)
                        IF(ierr==1)THEN
                              Sponge_south_width = 0.0_SP
                                    if (myid.eq.0) THEN
                                          WRITE(*,'(A40)')'Sponge_south_width Default:  0.0'
                                          WRITE(3,'(A40)')'Sponge_south_width Default:  0.0'
                                    endif
                        ENDIF
                  ! NORTH WIDTH
                  CALL READ_FLOAT(Sponge_north_width,FILE_NAME,'Sponge_north_width',ierr)
                  IF(ierr==1)THEN
                        Sponge_north_width = 0.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Sponge_north_width Default:  0.0'
                                    WRITE(3,'(A40)')'Sponge_north_width Default:  0.0'
                              endif
                  ENDIF

                  ! R SPONGE
                  CALL READ_FLOAT(R_sponge,FILE_NAME,'R_sponge',ierr)
                  IF(ierr==1)THEN
                        R_sponge = 0.85_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'R_sponge Default:  0.85'
                                    WRITE(3,'(A40)')'R_sponge Default:  0.85'
                              endif
                  ENDIF

                  ! A SPONGE
                  CALL READ_FLOAT(A_sponge,FILE_NAME,'A_sponge',ierr)
                        IF(ierr==1)THEN
                              A_sponge = 5.0_SP
                                    if (myid.eq.0) THEN
                                          WRITE(*,'(A40)')'A_sponge Default:  5.0'
                                          WRITE(3,'(A40)')'A_sponge Default:  5.0'
                                    endif
                        ENDIF

                  ! Write out parameters
                        if (myid.eq.0) WRITE(3,'(A20,F12.2)')'Sponge_west_width =', Sponge_west_width
                        if (myid.eq.0) WRITE(3,'(A20,F12.2)')'Sponge_east_width =', Sponge_east_width
                        if (myid.eq.0) WRITE(3,'(A20,F12.2)')'Sponge_south_width=', Sponge_south_width
                        if (myid.eq.0) WRITE(3,'(A20,F12.2)')'Sponge_north_width=', Sponge_north_width
                        if (myid.eq.0) WRITE(3,'(A20,F12.2)')'R_sponge          =', R_sponge
                        if (myid.eq.0) WRITE(3,'(A20,F12.2)')'A_sponge          =', A_sponge
            ENDIF 

! to avoid longshore current caused by extra momentum flux
! we can add bottom friction make momentum balance

      CALL READ_FLOAT(WaveMakerCd,FILE_NAME,'WaveMakerCd',ierr)
      IF(ierr==1)THEN
        WaveMakerCurrentBalance=.FALSE.
      if (myid.eq.0) WRITE(3,'(A40)')'No WavemakerCurrentBalance'
      ELSE
        WaveMakerCurrentBalance=.TRUE.
      if (myid.eq.0) WRITE(3,'(A15,F6.2)')'WaveMakerCd:', WaveMakerCd
      ENDIF

      !@! OBSTACLE AND BREAKWATER INFO
            if (myid.eq.0) WRITE(3,*)'                                         '
            if (myid.eq.0) WRITE(3,*)'-------- OBSTACLE and BREAKWATER -----------------'

            ! OBSTACLE FILE
            CALL READ_STRING(OBSTACLE_FILE,FILE_NAME,'OBSTACLE_FILE',ierr)
                  IF(ierr==1)THEN
                        OBSTACLE=.FALSE.
                              if (myid.eq.0) WRITE(3,'(A15,A5)')'OBSTACLE_FILE:', 'NO'
                  ELSE
                        OBSTACLE=.TRUE.
                              if (myid.eq.0) WRITE(3,'(A15,A50)')'OBSTACLE_FILE:', OBSTACLE_FILE
                  ENDIF

            ! BREAKWATER FILE
           CALL READ_STRING(BREAKWATER_FILE,FILE_NAME,'BREAKWATER_FILE',ierr)
                  IF(ierr==1)THEN
                        BREAKWATER=.FALSE.
                              if (myid.eq.0) WRITE(3,'(A20,A5)')'BREAKWATER_FILE:', 'NO'
                  ELSE
                        BREAKWATER=.TRUE.
                              if (myid.eq.0) WRITE(3,'(A20,A50)')'BREAKWATER_FILE:', BREAKWATER_FILE
                  ENDIF

            ! BREAKWATER REFLECTION STRENGTH
            CALL READ_FLOAT(BreakWaterAbsorbCoef,FILE_NAME,'BreakWaterAbsorbCoef',ierr)
            IF(ierr==1)THEN
                  BreakWaterAbsorbCoef = 10.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'BreakWaterAbsorbCoef Default:  10.0'
                              WRITE(3,'(A40)')'BreakWaterAbsorbCoef Default:  10.0'
                        endif
            ELSE
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40,F6.2)')'BreakWaterAbsorbCoef:', BreakWaterAbsorbCoef
                              WRITE(3,'(A40,F6.2)')'BreakWaterAbsorbCoef:', BreakWaterAbsorbCoef
                        endif
            ENDIF

      !@! PHYSICS INFORMATION
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- PHYSICS -----------------'

      !@! DISPERSION INFORMATION
            ! Dispersion type
            CALL READ_LOGICAL(DISPERSION,FILE_NAME,'DISPERSION',ierr)
                  IF(ierr==1)THEN
                        DISPERSION = .TRUE.
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'DISPERSION Default:  DISPERSION'
                                    WRITE(3,'(A40)')'DISPERSION Default:  DISPERSION'
                              endif
                  ENDIF
            ! Gamma1 and Gamma2parameter
            CALL READ_FLOAT(Gamma1,FILE_NAME,'Gamma1',ierr)
            IF(ierr==1)THEN
                  Gamma1 = 1.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'Gamma1 Default:  1.0: DISPERSION'
                              WRITE(3,'(A40)')'Gamma1 Default:  1.0: DISPERSION'
                        endif
            ENDIF

            ! Cartesian
                  CALL READ_FLOAT(Gamma2,FILE_NAME,'Gamma2',ierr)
                  IF(ierr==1)THEN
                        Gamma2 = 1.0_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A50)')'Gamma2 Default:  1.0: Full nonlinear'
                                    WRITE(3,'(A50)')'Gamma2 Default:  1.0: Full nonlinear'
                              endif
                  ENDIF

                  ! Beta parameter
                  CALL READ_FLOAT(Beta_ref,FILE_NAME,'Beta_ref',ierr)
                  IF(ierr==1)THEN
                        Beta_ref = - 0.531_SP
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Beta_ref Default:  -0.531'
                                    WRITE(3,'(A40)')'Beta_ref Default:  -0.531'
                              endif
                  ENDIF

            ! Spherical

            ! Gamma 3 parameter
            CALL READ_FLOAT(Gamma3,FILE_NAME,'Gamma3',ierr)
            IF(ierr==1)THEN
                  Gamma3 = 1.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A60)')'Gamma3 Default:  1.0: NOT fully linear'
                              WRITE(3,'(A60)')'Gamma3 Default:  1.0: NOT fully linear'
                        endif
            ENDIF

            ! Print out parameter information
                  if (myid.eq.0) WRITE(3,'(A20)')'Summary of Physics'
                  if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Gamma1 = ', Gamma1
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Gamma2 = ', Gamma2
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Beta_ref= ', Beta_ref
                        if (myid.eq.0) WRITE(3,'(A10,F12.2)')'Gamma3 = ', Gamma3

      !@! VISCOSITY BREAKING INFORMATION
            ! VISCOSITY BREAKING
            CALL READ_LOGICAL(VISCOSITY_BREAKING,FILE_NAME,'VISCOSITY_BREAKING',ierr)
            IF(ierr==1)THEN
                  VISCOSITY_BREAKING = .TRUE.
                        if (myid.eq.0) THEN
                              WRITE(*,'(A60)')'VISCOSITY_BREAKING Default:  VIS Breaking'
                              WRITE(3,'(A60)')'VISCOSITY_BREAKING Default:  VIS Breaking'
                        endif
            ENDIF

            IF(ROLLER) VISCOSITY_BREAKING = .TRUE.

            IF(VISCOSITY_BREAKING)THEN
                        if (myid.eq.0) WRITE(3,*)'VISCOSITY_BREAKING IS USED'
            ENDIF

            ! SWE_ETA_DEP
            CALL READ_FLOAT(SWE_ETA_DEP,FILE_NAME,'SWE_ETA_DEP',ierr)
            IF(ierr==1)THEN
                  SWE_ETA_DEP = 0.80_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'SWE_ETA_DEP Default:  0.8'
                              WRITE(3,'(A40)')'SWE_ETA_DEP Default:  0.8'
                        endif
            ENDIF


            IF(VISCOSITY_BREAKING)THEN
                  ! say nothing
            ELSE
                        if (myid.eq.0) WRITE(3,'(A13,F12.2)')'SWE_ETA_DEP=', SWE_ETA_DEP
            ENDIF

            ! FRICTION MATRIX
            CALL READ_LOGICAL(IN_Cd,FILE_NAME,'FRICTION_MATRIX',ierr)
            IF(ierr==1)THEN
                  IN_Cd = .FALSE.
                        if (myid.eq.0) THEN
                              WRITE(*,'(A50)')'Friction_Matrix Default:  constant Cd'
                              WRITE(3,'(A50)')'Friction_Matrix Default:  constant Cd'
                        endif
            ENDIF

            ! IN_Cd
            IF(IN_Cd)THEN
                  CALL READ_STRING(CD_FILE,FILE_NAME,'FRICTION_FILE',ierr) 
                  IF(ierr==1)THEN
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A80)')'FRICTION_FILE NOT FOUND, Please specify Cd_file in input.txt'
                                    WRITE(3,'(A80)')'FRICTION_FILE NOT FOUND, Please specify Cd_file in input.txt'
                              endif
                        call MPI_FINALIZE ( ier )
                        STOP
                  ELSE
                              if (myid.eq.0) WRITE(3,'(A15,A50)')'CD_FILE:', CD_FILE
                  ENDIF
            ENDIF 

            ! Cd 
            CALL READ_FLOAT(Cd_fixed,FILE_NAME,'Cd',ierr)
            IF(ierr==1)THEN
                  Cd_fixed = 0.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A80)')'Cd_fixed Default:  0.0, possibly you used FRICTION_MATRIX'
                              WRITE(3,'(A80)')'Cd_fixed Default:  0.0, possibly you used FRICTION_MATRIX'
                        endif
            ENDIF

            ! Print Cd information
                  if (myid.eq.0) WRITE(3,'(A35,F12.2)')'Cd_fixed (if you used fixed Cd) =', Cd_fixed

      !@! NUMERICS INFORMATION
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- NUMERICS -----------------'

            ! TIME SCHEME
            CALL READ_STRING(Time_Scheme,FILE_NAME,'Time_Scheme',ierr)
                  IF(ierr==1)THEN
                        Time_Scheme = 'Runge_Kutta'
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'Time_Scheme Default:  Runge_Kutta'
                                    WRITE(3,'(A40)')'Time_Scheme Default:  Runge_Kutta'
                              endif
                  ENDIF

                        if (myid.eq.0) WRITE(3,'(A13,A50)')'TIME_SCHEME:', TIME_SCHEME

            ! CONSTRUCTION
            CALL READ_STRING(CONSTR,FILE_NAME,'CONSTRUCTION',ierr)
                  IF(ierr==1)THEN
                              if (myid.eq.0) WRITE(3,'(A14,A50)')'CONSTRUCTION', 'NOT DEFINED, USE HLL'
                        CONSTR='HLLC'
                  ENDIF

                        if (myid.eq.0) WRITE(3,'(A14,A50)')'CONSTRUCTION:', CONSTR

            ! HIGH ORDER
            CALL READ_STRING(HIGH_ORDER,FILE_NAME,'HIGH_ORDER',ierr)
            IF(ierr==1)THEN
                        if (myid.eq.0)then
                              WRITE(*,'(A12,A50)')'HIGH_ORDER', 'NOT DEFINED, USE FOURTH-ORDER'
                              WRITE(3,'(A12,A50)')'HIGH_ORDER', 'NOT DEFINED, USE FOURTH-ORDER'
                        endif
                        HIGH_ORDER='FOURTH'        
            ENDIF

                  if (myid.eq.0) WRITE(3,'(A12,A50)')'HIGH_ORDER:', HIGH_ORDER

            ! CFL NUMBER
            CALL READ_FLOAT(CFL,FILE_NAME,'CFL',ierr)
            IF(ierr==1)THEN
                  CFL = 0.5_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'CFL Default:  0.5'
                              WRITE(3,'(A40)')'CFL Default:  0.5'
                        endif
            ENDIF

                  if (myid.eq.0) WRITE(3,'(A5,F12.2)')'CFL=', CFL

            ! DT FIXED
            CALL READ_FLOAT(DT_fixed,FILE_NAME,'DT_fixed',ierr)
            IF (ierr.ne.1) THEN
                  FIXED_DT = .TRUE.
                        if (myid.eq.0) then
                              WRITE(3,'(A80)') 'use fixed DT, but judged by CFL. IF not satisfy CLF, DT/2...'
                              WRITE(3,'(A12,F12.2)')'DT_fixed= ', DT_fixed
                        endif
            ENDIF ! ierr\=1
  
      !@! Froude Number Cap
            CALL READ_FLOAT(FroudeCap,FILE_NAME,'FroudeCap',ierr)
            IF(ierr==1)THEN
                  FroudeCap = 3.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'FroudeCap Default:  3.0'
                              WRITE(3,'(A40)')'FroudeCap Default:  3.0'
                        endif
            ENDIF

                  if (myid.eq.0) WRITE(3,'(A12,F12.2)')'FroudeCap=', FroudeCap

      !@! MinDepth
            CALL READ_FLOAT(MinDepth,FILE_NAME,'MinDepth',ierr)
            IF(ierr==1)THEN
                  MinDepth = 0.1_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'MinDepth Default:  0.1 m'
                              WRITE(3,'(A40)')'MinDepth Default:  0.1 m'
                        endif
            ENDIF

            CALL READ_FLOAT(MinDepthFrc,FILE_NAME,'MinDepthFrc',ierr)
            IF(ierr==1)THEN
                  MinDepthFrc = 0.1_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'MinDepthFrc Default:  0.1 m'
                              WRITE(3,'(A40)')'MinDepthFrc Default:  0.1 m'
                        endif
            ENDIF

            !  merge two parameters into the minimum one, change to min according to Harris 11/13/2023
                  MinDepthFrc=MIN(MinDepthFrc,MinDepth)
                  MinDepth=MinDepthFrc

                  if (myid.eq.0) WRITE(3,'(A40)')'USE MIN(MinDepthFrc, MinDepth)'

            ! Print out parameters
                  if (myid.eq.0) WRITE(3,'(A10,F12.6)')'MinDepth=', MinDepth

                  if (myid.eq.0) WRITE(3,'(A13,F12.6)')'MinDepthFrc=', MinDepthFrc

      !@! Lauren Arrival Time
            !$! OUT_Time (Boolean): Record arrival time?
            CALL READ_LOGICAL(OUT_Time,FILE_NAME,'OUT_Time',ierr)
            IF(ierr==1)THEN
                  OUT_Time = .FALSE.
                        if (myid.eq.0) THEN
                              WRITE(*,'(A60)')'Dont record wave arrival time'
                              WRITE(3,'(A60)')'Dont record wave arrival time'
                        endif
            ELSE
                        if (myid.eq.0) THEN
                              WRITE(*,'(A60)')'Record wave arrival time'
                              WRITE(3,'(A60)')'Record wave arrival time'
                        endif
            ENDIF
      
            !$! ArrTimeMinH (Float): Threshold for arrival time
            IF(OUT_Time)THEN
                  CALL READ_FLOAT(ArrTimeMin,FILE_NAME,'ArrTimeMinH',ierr)
                  IF(ierr==1)THEN
                        ArrTimeMin = 0.001 ! set equal to 0.1 cm if no threshold is given
                              if (myid.eq.0) THEN
                                    WRITE(*,'(A40)')'ArrTimeMinH Default:  0.001 m'
                                    WRITE(3,'(A40)')'ArrTimeMinH Default:  0.001 m'
                              endif
                  ENDIF
                              
                        if (myid.eq.0) WRITE(3,'(A10,F12.6)')'ArrTimeMinH', ArrTimeMin
            ENDIF

      !@! WAVE BREAKING
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'--------- WAVE BREAKING -----------------'

            !$! ROLLER_EFFECT (Boolean): Whether or not to include roller)
            CALL READ_LOGICAL(ROLLER,FILE_NAME,'ROLLER_EFFECT',ierr)
            IF(ierr==1)THEN
                  ROLLER = .FALSE.
            ENDIF

            ! Include roller effect
            IF(ROLLER)THEN
                  ROLLER_SWITCH = 1.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'ROLLER_EFFECT:  INCLUDED'
                              WRITE(3,'(A40)')'ROLLER_EFFECT:  INCLUDED'
                        endif
            ! Do not include roller effect
            ELSE
                  ROLLER_SWITCH = ZERO
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'ROLLER_EFFECT:  NO'
                              WRITE(3,'(A40)')'ROLLER_EFFECT:  NO'
                        endif
            ENDIF



            !$! SHOW_BREAKING (Boolean): Whether or not to show breaking
            CALL READ_LOGICAL(SHOW_BREAKING,FILE_NAME,'SHOW_BREAKING',ierr)
            IF(ierr==1)THEN
                  SHOW_BREAKING = .TRUE.
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'SHOW_BREAKING Default:  TRUE'
                              WRITE(3,'(A40)')'SHOW_BREAKING Default:  TRUE'
                        endif
            ENDIF
	
            IF(VISCOSITY_BREAKING) SHOW_BREAKING = .TRUE.

            IF(SHOW_BREAKING)THEN
                  !$! Cbrk1 (Float): Breaking parameter 1
                  CALL READ_FLOAT(Cbrk1,FILE_NAME,'Cbrk1',ierr)
                  IF(ierr==1)THEN
                        Cbrk1 = 0.65_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'Cbrk1 Default:  0.65'
                              WRITE(3,'(A40)')'Cbrk1 Default:  0.65'
                        endif
            ENDIF

            IF(VISCOSITY_BREAKING)THEN
                        if (myid.eq.0) WRITE(3,'(A8,F12.6)')'Cbrk1 =', Cbrk1
            ENDIF

            !$! Cbrk2 (Float): Breaking parameter 2
            CALL READ_FLOAT(Cbrk2,FILE_NAME,'Cbrk2',ierr)
            IF(ierr==1)THEN
                  Cbrk2 = 0.35_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'Cbrk2 Default:  0.35'
                              WRITE(3,'(A40)')'Cbrk2 Default:  0.35'
                        endif
            ENDIF

            ! Write out Cbrk2 parameter
            IF(VISCOSITY_BREAKING)THEN
                        if (myid.eq.0) WRITE(3,'(A8,F12.6)')'Cbrk2 =', Cbrk2
            ENDIF

            !$! WAVEMAKER_Cbrk (Float): Wavemaker Cbrk parameter
            CALL READ_FLOAT(WAVEMAKER_Cbrk,FILE_NAME,'WAVEMAKER_Cbrk',ierr)
            IF(ierr==1)THEN
                  WAVEMAKER_Cbrk = 1.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'WAVEMAKER_Cbrk Default:  1.0'
                              WRITE(3,'(A40)')'WAVEMAKER_Cbrk Default:  1.0'
                        endif
             ENDIF
            ! Write out parameter
                  if (myid.eq.0) WRITE(3,'(A18,F17.6)')'WAVEMAKER_Cbrk =', WAVEMAKER_Cbrk
                  ENDIF

            !$! Wavemaker viscosity
            CALL READ_LOGICAL(WAVEMAKER_VIS,FILE_NAME,'WAVEMAKER_VIS',ierr)  
            IF(ierr==1)THEN
                  WAVEMAKER_VIS = .FALSE.
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'WAVEMAKER_VIS Default:  FALSE'
                              WRITE(3,'(A40)')'WAVEMAKER_VIS Default:  FALSE'
                        endif
            ENDIF

            ! Error handling for viscosity breaking and wavemaker viscosity
	      IF( VISCOSITY_BREAKING .AND. WAVEMAKER_VIS ) THEN
                        IF (myid.eq.0) then
                              WRITE(*,*) "==============================================="
                              WRITE(*,*)  "STOP :: VISCOSITY_BREAKING=T, WAVEMAKER_VIS=T"
                              WRITE(*,*) "==============================================="
                        ENDIF
                        call MPI_FINALIZE ( ier )
            ENDIF

            ! Print out wavemaker viscosity
            IF(WAVEMAKER_VIS)THEN
                        if (myid.eq.0) WRITE(3,*)'WAVEMAKER_VIS'
            ENDIF

            !$! WAVEMAKER_visbrk (Floats): suggested not to use (?)
                  IF(WAVEMAKER_VIS)THEN
                        CALL READ_FLOAT(visbrk,FILE_NAME,'visbrk',ierr)
                        CALL READ_FLOAT(WAVEMAKER_visbrk,FILE_NAME,'WAVEMAKER_visbrk',ierr)
                              if (myid.eq.0) WRITE(3,'(A14,F12.6)')'visbrk =', visbrk
                              if (myid.eq.0) WRITE(3,'(A8,F12.6)')'WAVEMAKER_visbrk =', WAVEMAKER_visbrk
	            ENDIF

      !@! WAVE AVERAGED PROPERTIES
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------- WAVE-AVERAGED PROPERTY -----------------'

            !#! T_INTV_mean (Float): Time to take mean
            CALL READ_FLOAT(T_INTV_mean,FILE_NAME,'T_INTV_mean',ierr)
            IF(ierr==1)THEN
                  T_INTV_mean = LARGE
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'T_INTV_mean Default:  LARGE'
                              WRITE(3,'(A40)')'T_INTV_mean Default:  LARGE'
                        endif
            ENDIF

            !#! STEADY_TIME (Float): Time until steady
	      CALL READ_FLOAT(STEADY_TIME,FILE_NAME,'STEADY_TIME',ierr)
            IF(ierr==1)THEN
                  STEADY_TIME = LARGE
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'STEADY_TIME Default:  LARGE'
                              WRITE(3,'(A40)')'STEADY_TIME Default:  LARGE'
                        endif
            ENDIF

            !#! C_smg (Float): C Smagorinski (?)
            CALL READ_FLOAT(C_smg,FILE_NAME,'C_smg',ierr)
            IF(ierr==1)THEN
                  C_smg = 0.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'C_smg Default:  0.0'
                              WRITE(3,'(A40)')'C_smg Default:  0.0'
                        endif
            ENDIF

            ! Print out parameters
                  if (myid.eq.0) WRITE(3,'(A14,F12.6)')'T_INTV_mean =', T_INTV_mean
                  if (myid.eq.0) WRITE(3,'(A14,F12.6)')'STEADY_TIME =', STEADY_TIME
                  if (myid.eq.0) WRITE(3,'(A8,F12.6)')'C_smg =', C_smg
	
            !#! nu_bkg (Float): nu for breaking
            CALL READ_FLOAT(nu_bkg,FILE_NAME,'nu_bkg',ierr)
            IF(ierr==1)THEN
                  nu_bkg = 0.0_SP
                        if (myid.eq.0) THEN
                              WRITE(*,'(A40)')'nu_bkg Default:  0.0'
                              WRITE(3,'(A40)')'nu_bkg Default:  0.0'
                        endif
            ENDIF
      
      !@! COUPLING
      !@! OUTPUT INFO
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)'-------------- OUTPUT INFO -----------------'

            !$! RESULT_FOLDER (String): folder where results will go
            CALL READ_STRING(RESULT_FOLDER,FILE_NAME,'RESULT_FOLDER',ierr)
            ! Default to 'output` name
            IF(ierr==1)THEN
                  RESULT_FOLDER = './output/'
            ENDIF
            ! Print out RESULT_FOLDER
                  if (myid.eq.0) WRITE(3,'(A15,A50)')'RESULT_FOLDER:', RESULT_FOLDER

      !@! BINARY/ASCII OUTPUTS
                  !$! FIELD_IO_TYPE (String): type for output (binary of ascii)
                  CALL READ_STRING(FIELD_IO_TYPE,FILE_NAME,'FIELD_IO_TYPE',ierr)
                  ! Default to ASCII
                  IF(ierr.EQ.1) FIELD_IO_TYPE = 'ASCII'
                  
                  IF (myid.EQ.0) WRITE(3,*) 'FIELD_IO_TYPE = ' , FIELD_IO_TYPE
 
      !@! CREATION OF RESULT FOLDER
            MKFOLDER = "mkdir -p "//TRIM(RESULT_FOLDER)
                  IF (myid.eq.0) THEN
                              CALL SYSTEM(TRIM(MKFOLDER))
                  ENDIF


      !@! OUTPUT PARAMETERS
            !$! OUTPUT_RES
            CALL READ_INTEGER(OUTPUT_RES,FILE_NAME,'OUTPUT_RES',ierr)
            IF(ierr==1)THEN
                  OUTPUT_RES = 1
                        if (myid.eq.0) THEN
                              WRITE(*,'(A60)')'OUTPUT_RES NOT FOUND, OUTPUT_RES=1: full resolution'
                              WRITE(3,'(A60)')'OUTPUT_RES NOT FOUND, OUTPUT_RES=1: full resolution'
                        endif
            ENDIF

            ! Print out OUTPUT_RES
                  if (myid.eq.0) WRITE(3,'(A15,I10)')'OUTPUT_RES',OUTPUT_RES

      !@! FINAL ROLL CALL OF VARIABLES
            CALL READ_LOGICAL(OUT_DEPTH,FILE_NAME,'DEPTH_OUT',ierr)
            CALL READ_LOGICAL(OUT_U,FILE_NAME,'U',ierr)
            CALL READ_LOGICAL(OUT_V,FILE_NAME,'V',ierr)
            CALL READ_LOGICAL(OUT_ETA,FILE_NAME,'ETA',ierr)
            CALL READ_LOGICAL(OUT_Hmax,FILE_NAME,'Hmax',ierr)
            CALL READ_LOGICAL(OUT_Hmin,FILE_NAME,'Hmin',ierr)
            CALL READ_LOGICAL(OUT_Umax,FILE_NAME,'Umax',ierr)
            CALL READ_LOGICAL(OUT_MFmax,FILE_NAME,'MFmax',ierr)
            CALL READ_LOGICAL(OUT_VORmax,FILE_NAME,'VORmax',ierr)
            CALL READ_LOGICAL(OUT_MASK,FILE_NAME,'MASK',ierr)
            CALL READ_LOGICAL(OUT_MASK9,FILE_NAME,'MASK9',ierr)
            CALL READ_LOGICAL(OUT_Umean,FILE_NAME,'Umean',ierr)
            CALL READ_LOGICAL(OUT_Vmean,FILE_NAME,'Vmean',ierr)
            CALL READ_LOGICAL(OUT_ETAmean,FILE_NAME,'ETAmean',ierr)
            CALL READ_LOGICAL(OUT_WaveHeight,FILE_NAME,'WaveHeight',ierr)
            CALL READ_LOGICAL(OUT_SXL,FILE_NAME,'SXL',ierr)
            CALL READ_LOGICAL(OUT_SXR,FILE_NAME,'SXR',ierr)
            CALL READ_LOGICAL(OUT_SYL,FILE_NAME,'SYL',ierr)
            CALL READ_LOGICAL(OUT_SYR,FILE_NAME,'SYR',ierr)
            CALL READ_LOGICAL(OUT_SourceX,FILE_NAME,'SourceX',ierr)
            CALL READ_LOGICAL(OUT_SourceY,FILE_NAME,'SourceY',ierr)
            CALL READ_LOGICAL(OUT_FrcX,FILE_NAME,'FrcX',ierr)
            CALL READ_LOGICAL(OUT_FrcY,FILE_NAME,'FrcY',ierr)
            CALL READ_LOGICAL(OUT_BrkdisX,FILE_NAME,'BrkdisX',ierr)
            CALL READ_LOGICAL(OUT_BrkdisY,FILE_NAME,'BrkdisY',ierr)
            CALL READ_LOGICAL(OUT_P,FILE_NAME,'P',ierr)
            CALL READ_LOGICAL(OUT_Q,FILE_NAME,'Q',ierr)
            CALL READ_LOGICAL(OUT_Fx,FILE_NAME,'Fx',ierr)
            CALL READ_LOGICAL(OUT_Fy,FILE_NAME,'Fy',ierr)
            CALL READ_LOGICAL(OUT_Gx,FILE_NAME,'Gx',ierr)
            CALL READ_LOGICAL(OUT_Gy,FILE_NAME,'Gy',ierr)
            CALL READ_LOGICAL(OUT_AGE,FILE_NAME,'AGE',ierr)
            CALL READ_LOGICAL(OUT_ROLLER,FILE_NAME,'ROLLER',ierr)
            CALL READ_LOGICAL(OUT_UNDERTOW,FILE_NAME,'UNDERTOW',ierr)
            CALL READ_LOGICAL(OUT_NU,FILE_NAME,'OUT_NU',ierr)
            CALL READ_LOGICAL(OUT_TMP,FILE_NAME,'TMP',ierr) 
            CALL READ_LOGICAL(OUT_Radiation,FILE_NAME,'Radiation',ierr) 

      !@! EtaBlowUp Value
      IF(ierr==1)THEN
            EtaBlowVal = 10.0_SP
                  if (myid.eq.0) THEN
                        WRITE(*,'(A40)')'EtaBlowVal Default:  100xmax_depth'
                        WRITE(3,'(A40)')'EtaBlowVal Default:  100xmax_depth'
                  endif
       ENDIF

      !@! FINAL WRITING OF ALL VARIABLES
                  if (myid.eq.0)   then
                  WRITE(3,'(A15,L2)')'OUT_DEPTH',OUT_DEPTH
                  WRITE(3,'(A15,L2)')'OUT_U',OUT_U
                  WRITE(3,'(A15,L2)')'OUT_V',OUT_V
                  WRITE(3,'(A15,L2)')'OUT_ETA',OUT_ETA
                  WRITE(3,'(A15,L2)')'OUT_Hmax',OUT_Hmax
                  WRITE(3,'(A15,L2)')'OUT_Hmin',OUT_Hmin
                  WRITE(3,'(A15,L2)')'OUT_Umax',OUT_Umax
                  WRITE(3,'(A15,L2)')'OUT_MFmax',OUT_MFmax
                  WRITE(3,'(A15,L2)')'OUT_VORmax',OUT_VORmax
                  WRITE(3,'(A15,L2)')'OUT_MASK',OUT_MASK
                  WRITE(3,'(A15,L2)')'OUT_MASK9',OUT_MASK9
                  WRITE(3,'(A15,L2)')'OUT_Umean',OUT_Umean
                  WRITE(3,'(A15,L2)')'OUT_Vmean',OUT_Vmean
                  WRITE(3,'(A15,L2)')'OUT_ETAmean',OUT_ETAmean
                  WRITE(3,'(A15,L2)')'OUT_WaveHeight',OUT_WaveHeight
                  WRITE(3,'(A15,L2)')'OUT_SXL',OUT_SXL
                  WRITE(3,'(A15,L2)')'OUT_SXR',OUT_SXR
                  WRITE(3,'(A15,L2)')'OUT_SYL',OUT_SYL
                  WRITE(3,'(A15,L2)')'OUT_SYR',OUT_SYR
                  WRITE(3,'(A15,L2)')'OUT_SourceX',OUT_SourceX
                  WRITE(3,'(A15,L2)')'OUT_SourceY',OUT_SourceY
                  WRITE(3,'(A15,L2)')'OUT_P',OUT_P
                  WRITE(3,'(A15,L2)')'OUT_Q',OUT_Q
                  WRITE(3,'(A15,L2)')'OUT_Fx',OUT_Fx
                  WRITE(3,'(A15,L2)')'OUT_Fy',OUT_Fy
                  WRITE(3,'(A15,L2)')'OUT_Gx',OUT_Gx
                  WRITE(3,'(A15,L2)')'OUT_Gy',OUT_Gy
                  WRITE(3,'(A15,L2)')'OUT_AGE',OUT_AGE
                  WRITE(3,'(A15,L2)')'OUT_ROLLER',OUT_ROLLER
                  WRITE(3,'(A15,L2)')'OUT_UNDERTOW',OUT_UNDERTOW
                  WRITE(3,'(A15,L2)')'OUT_NU',OUT_NU
                  WRITE(3,'(A15,L2)')'OUT_TMP',OUT_TMP
                  WRITE(3,'(A15,L2)')'OUT_TIME',OUT_Time
                  endif

      !@! INPUT ENED
                  if (myid.eq.0) WRITE(3,*)'                                         '
                  if (myid.eq.0) WRITE(3,*)' --------------input end --------------' 
                  if (myid.eq.0) WRITE(3,*)'                                         '
END SUBROUTINE READ_INPUT



!-------------------------------------------------------------------------------------
!
!    PREVIEW is subroutine for print-out of field data
!
!  HISTORY:
!    05/01/2010  Fengyan Shi
!    06/01/2015  Young-Kwang Choi, change file number to 5 digits, 
!                        such as eta_00001
!
!-------------------------------------------------------------------------------------
SUBROUTINE PREVIEW
      ! Import necessary modules
      USE GLOBAL
      IMPLICIT NONE

      !! Variable Declarations
      CHARACTER(LEN=80)::FILE_NAME=' '
      CHARACTER(LEN=80)::FILE_NAME_MEAN=' '
      CHARACTER(LEN=80)::TMP_NAME=' '
      CHARACTER(LEN=80)::FDIR=' '

      ! RESULT_FOLDER from earlier
      FDIR=TRIM(RESULT_FOLDER)
      ! Iteration counter
      ICOUNT=ICOUNT+1

      !! Display progress of iteration
                  if (myid.eq.0)then
                  WRITE(3,102)'PRINTING FILE NO.', icount, ' TIME/TOTAL: ', TIME,'/',Total_Time
                  WRITE(*,102)'PRINTING FILE NO.', icount, ' TIME/TOTAL: ', TIME,'/',Total_Time        
                  endif

            102     FORMAT(A20,I6,A14,F12.3,A2,F12.3)


            itmp1=mod(icount/10000,10)
            itmp2=mod(icount/1000,10)
            itmp3=mod(icount/100,10)
            itmp4=mod(icount/10,10)
            itmp5=mod(icount,10)

            write(file_name(1:1),'(I1)')itmp1
            write(file_name(2:2),'(I1)')itmp2
            write(file_name(3:3),'(I1)')itmp3
            write(file_name(4:4),'(I1)')itmp4
            write(file_name(5:5),'(I1)')itmp5   !ykchoi
      
      
      !! Things to do on first iteration
            IF(ICOUNT==1)THEN
            IF(OUT_DEPTH.OR.BREAKWATER)THEN
                  TMP_NAME = TRIM(FDIR)//'dep.out'
                  call PutFile(TMP_NAME,DEPTH)
                  TMP_NAME = TRIM(FDIR)//'cd_breakwater.out'
                  call PutFile(TMP_NAME,CD_breakwater)
            ENDIF
            ENDIF

      !! Write out time to time_dt file
            write(10000,*)time, dt
      
      !! Write out variables of iterest at each timestep
            IF(OUT_ETA)THEN
                  TMP_NAME = TRIM(FDIR)//'eta_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,Eta)
            ENDIF


            IF(OUT_Hmax)THEN
                  TMP_NAME = TRIM(FDIR)//'hmax_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,HeightMax)
            ENDIF

            IF(OUT_Hmin)THEN
                  TMP_NAME = TRIM(FDIR)//'hmin_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,HeightMin)
            ENDIF

            IF(OUT_Umax)THEN
                  TMP_NAME = TRIM(FDIR)//'umax_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,VelocityMax)
            ENDIF
            
            IF(OUT_MFmax)THEN                                                                                            
                  TMP_NAME = TRIM(FDIR)//'MFmax_'//TRIM(FILE_NAME)                                                          
                  call PutFile(TMP_NAME,MomentumFluxMax)                                                                              
            ENDIF      
            
            IF(OUT_VORmax)THEN                                                                                            
                  TMP_NAME = TRIM(FDIR)//'VORmax_'//TRIM(FILE_NAME)                                                          
                  call PutFile(TMP_NAME,VorticityMax)                                                                              
            ENDIF            
            
            IF(OUT_U)THEN
                  TMP_NAME = TRIM(FDIR)//'u_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,U)
            ENDIF

            IF(OUT_V)THEN
                  TMP_NAME = TRIM(FDIR)//'v_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,V)
            ENDIF

            IF(OUT_MASK)THEN
                  TMP_NAME = TRIM(FDIR)//'mask_'//TRIM(FILE_NAME)
                  Int2Flo=MASK
                  call PutFile(TMP_NAME,Int2Flo)
            ENDIF

            IF(OUT_MASK9)THEN
                  TMP_NAME = TRIM(FDIR)//'mask9_'//TRIM(FILE_NAME)
                  Int2Flo=MASK9
                  call PutFile(TMP_NAME,Int2Flo)
            ENDIF

      210   FORMAT(5000I3)

            IF(OUT_P)THEN
                  TMP_NAME = TRIM(FDIR)//'p_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,P(1:Mloc,1:Nloc))
            ENDIF

            IF(OUT_Q)THEN
                  TMP_NAME = TRIM(FDIR)//'q_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,Q(1:Mloc,1:Nloc))
            ENDIF


            IF(OUT_AGE)THEN
                  IF(SHOW_BREAKING)THEN
                  TMP_NAME = TRIM(FDIR)//'age_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,AGE_BREAKING)
                  ENDIF
            ENDIF

            IF(OUT_ROLLER)THEN
                  TMP_NAME = TRIM(FDIR)//'roller_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,ROLLER_FLUX)
            ENDIF

            IF(OUT_UNDERTOW)THEN
                  TMP_NAME = TRIM(FDIR)//'U_undertow_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,UNDERTOW_U)
                  TMP_NAME = TRIM(FDIR)//'V_undertow_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,UNDERTOW_V)
            ENDIF

                  IF(VISCOSITY_BREAKING)THEN
                  IF(OUT_NU)THEN
                  TMP_NAME = TRIM(FDIR)//'nubrk_'//TRIM(FILE_NAME)
                  call PutFile(TMP_NAME,nu_break)
                  ENDIF

      ENDIF

       IF(OUT_FrcX)THEN
            TMP_NAME = TRIM(FDIR)//'FrcInsX_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,FrcInsX)
       ENDIF
       IF(OUT_FrcY)THEN
            TMP_NAME = TRIM(FDIR)//'FrcInsY_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,FrcInsY)
       ENDIF
       IF(OUT_BrkdisX)THEN
            TMP_NAME = TRIM(FDIR)//'BrkSrcX_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,BreakSourceX)
       ENDIF
       IF(OUT_BrkdisY)THEN
            TMP_NAME = TRIM(FDIR)//'BrkSrcY_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,BreakSourceY)
       ENDIF


      IF(OUT_Time)THEN
            TMP_NAME = TRIM(FDIR)//'time_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,ARRTIME)
      ENDIF


101   continue

END SUBROUTINE PREVIEW

!-------------------------------------------------------------------------------------
!
!    PREVIEW_MEAN is subroutine for print-out of mean field data
!
!  HISTORY:
!    03/22/2016  Fengyan Shi
!-------------------------------------------------------------------------------------
SUBROUTINE PREVIEW_MEAN
      USE GLOBAL
      IMPLICIT NONE
      REAL(SP),DIMENSION(Mloc,Nloc) :: tmpout 

      CHARACTER(LEN=80)::FILE_NAME=' '
      CHARACTER(LEN=80)::FDIR=' '
      CHARACTER(LEN=80)::TMP_NAME=' '

      FDIR=TRIM(RESULT_FOLDER)

      ICOUNT_MEAN=ICOUNT_MEAN+1

            if (myid.eq.0)then
            WRITE(3,102)'PRINTING MEAN FILE', icount_mean
            WRITE(*,102)'PRINTING MEAN FILE', icount_mean
            endif

      102     FORMAT(A20,I6)

            itmp1=mod(icount_mean/10000,10)
            itmp2=mod(icount_mean/1000,10)
            itmp3=mod(icount_mean/100,10)
            itmp4=mod(icount_mean/10,10)
            itmp5=mod(icount_mean,10)

            write(file_name(1:1),'(I1)')itmp1
            write(file_name(2:2),'(I1)')itmp2
            write(file_name(3:3),'(I1)')itmp3
            write(file_name(4:4),'(I1)')itmp4
            write(file_name(5:5),'(I1)')itmp5  

      IF(OUT_Umean)THEN
            TMP_NAME = TRIM(FDIR)//'umean_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,Umean)
            tmpout = P_mean / Max(Depth+ETAmean,MinDepthFrc)
            TMP_NAME = TRIM(FDIR)//'ulagm_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,tmpout)
      ENDIF
      
      IF(OUT_Vmean)THEN
            TMP_NAME = TRIM(FDIR)//'vmean_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,Vmean)
            tmpout = Q_mean / Max(Depth+ETAmean,MinDepthFrc)
            TMP_NAME = TRIM(FDIR)//'vlagm_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,tmpout)
      ENDIF

      IF(OUT_ETAmean)THEN
          TMP_NAME = TRIM(FDIR)//'etamean_'//TRIM(FILE_NAME)
          call PutFile(TMP_NAME,ETAmean)
      ENDIF

      IF(OUT_WaveHeight)THEN
            TMP_NAME = TRIM(FDIR)//'Hrms_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,WaveHeightRMS)
            TMP_NAME = TRIM(FDIR)//'Havg_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,WaveHeightAve)
            TMP_NAME = TRIM(FDIR)//'Hsig_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,SigWaveHeight)
      ENDIF


      IF(OUT_Radiation)THEN
            TMP_NAME = TRIM(FDIR)//'Sxx_'//TRIM(FILE_NAME)
            tmpout = UUmean-WWmean+0.5*9.8*ETA2mean
            call PutFile(TMP_NAME,tmpout)
            TMP_NAME = TRIM(FDIR)//'Sxy_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,UVmean)
            TMP_NAME = TRIM(FDIR)//'Syy_'//TRIM(FILE_NAME)
            tmpout = VVmean-WWmean+0.5*9.8*ETA2mean
            call PutFile(TMP_NAME,tmpout)

            TMP_NAME = TRIM(FDIR)//'DxSxx_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DxSxx)
            TMP_NAME = TRIM(FDIR)//'DySxy_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DySxy)
            TMP_NAME = TRIM(FDIR)//'DySyy_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DySyy)
            TMP_NAME = TRIM(FDIR)//'DxSxy_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DxSxy)
            TMP_NAME = TRIM(FDIR)//'PgrdX_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,PgrdX)
            TMP_NAME = TRIM(FDIR)//'PgrdY_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,PgrdY)
            TMP_NAME = TRIM(FDIR)//'DxUUH_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DxUUH)
            TMP_NAME = TRIM(FDIR)//'DyUVH_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DyUVH)
            TMP_NAME = TRIM(FDIR)//'DyVVH_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DyVVH)
            TMP_NAME = TRIM(FDIR)//'DxUVH_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,DxUVH)
            TMP_NAME = TRIM(FDIR)//'FRCX_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,FRCXmean)
            TMP_NAME = TRIM(FDIR)//'FRCY_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,FRCYmean)
            TMP_NAME = TRIM(FDIR)//'BrkDissX_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,BreakDissX)
            TMP_NAME = TRIM(FDIR)//'BrkDissY_'//TRIM(FILE_NAME)
            call PutFile(TMP_NAME,BreakDissY)

        ENDIF
                    

END SUBROUTINE PREVIEW_MEAN


!-------------------------------------------------------------------------------------
!
!    GetFile is subroutine for reading field data
!
!    HISTORY:
!    05/01/2010  Fengyan Shi
!    05/08/2017  Young-Kwang Choi
!-------------------------------------------------------------------------------------

SUBROUTINE GetFile(FILE,PHI)
      USE GLOBAL
      IMPLICIT NONE

      REAL(SP),DIMENSION(MGlob+2*Nghost,NGlob+2*Nghost) :: PHIGLOB
      CHARACTER(LEN=80) FILE
      REAL(SP),DIMENSION(Mloc,Nloc),INTENT(OUT) :: PHI

![-------ykchoi (08/May/2017)
      INTEGER :: irank, lenx, leny, lenxy, ireq
      INTEGER :: Nista, Niend, Njsta, Njend
      INTEGER :: istanum, iendnum, jstanum, jendnum
      INTEGER, ALLOCATABLE :: Nistas(:), Niends(:), Njstas(:), Njends(:)
      INTEGER :: istatus(mpi_status_size)
      REAL(SP), ALLOCATABLE :: xx(:,:)
! -------ykchoi (08/May/2017) ]

! TEMP

      if (myid.eq.0) then
            OPEN(1,FILE=TRIM(FILE))
            DO J=Nghost+1,NGlob+NGhost
            READ(1,*)(PHIGLOB(I,J),I=Nghost+1,MGlob+Nghost)
            ENDDO
            CLOSE(1)
      ! ghost cells
            DO I=Nghost+1,MGlob+Nghost
            DO J=1,Nghost
                  PHIGLOB(I,J)=PHIGLOB(I,Nghost+1)
            ENDDO
            DO J=NGlob+Nghost+1,NGlob+2*Nghost
                  PHIGLOB(I,J)=PHIGLOB(I,NGlob+Nghost)
            ENDDO
            ENDDO
            DO J=1,NGlob+2*Nghost
            DO I=1,Nghost
                  PHIGLOB(I,J)=PHIGLOB(Nghost+1,J)
            ENDDO
            DO I=MGlob+Nghost+1,MGlob+2*Nghost
                  PHIGLOB(I,J)=PHIGLOB(MGlob+Nghost,J)
            ENDDO
            ENDDO
      endif

      ![-------ykchoi (08/May/2017)
      Nista = iista + Nghost;
      Niend = iiend + Nghost;
      Njsta = jjsta + Nghost;
      Njend = jjend + Nghost;

      allocate( Nistas(nprocs), Niends(nprocs), Njstas(nprocs), Njends(nprocs) )

      call MPI_Gather( Nista, 1, MPI_INTEGER, Nistas, 1, MPI_INTEGER, &
                        0, MPI_COMM_WORLD, ier )
      call MPI_Gather( Niend, 1, MPI_INTEGER, Niends, 1, MPI_INTEGER, &
                        0, MPI_COMM_WORLD, ier )
      call MPI_Gather( Njsta, 1, MPI_INTEGER, Njstas, 1, MPI_INTEGER, &
                        0, MPI_COMM_WORLD, ier )
      call MPI_Gather( Njend, 1, MPI_INTEGER, Njends, 1, MPI_INTEGER, &
                        0, MPI_COMM_WORLD, ier )

      if( myid == 0 )then
            PHI = PHIGLOB( 1:Mloc, 1:Nloc )
      endif

      do irank=1, px*py-1
            if( myid == 0 ) then
            istanum = Nistas(irank+1) - Nghost
            iendnum = Niends(irank+1) + Nghost
            jstanum = Njstas(irank+1) - Nghost
            jendnum = Njends(irank+1) + Nghost

            lenx = iendnum - istanum + 1
            leny = jendnum - jstanum + 1
            lenxy = lenx*leny
            allocate( xx(lenx, leny) )

            xx = PHIGLOB( istanum:iendnum, jstanum:jendnum )
            call mpi_isend( xx, lenxy, mpi_sp, irank, 1, mpi_comm_world, ireq, ier )
            call mpi_wait( ireq, istatus, ier )
            deallocate( xx )

            elseif( myid == irank ) then
            
            lenx = Niend-Nista+1+2*Nghost
            leny = Njend-Njsta+1+2*Nghost
            lenxy = lenx*leny

            call mpi_irecv( PHI, lenxy, mpi_sp, 0, 1, mpi_comm_world, ireq, ier )
            call mpi_wait( ireq, istatus, ier )

            endif
      enddo

      deallocate( Nistas, Niends, Njstas, Njends )

! -------ykchoi (08/May/2017) ]

END SUBROUTINE Getfile


!-------------------------------------------------------------------------------------
!
!    PutFile is subroutine for print-out of field data
!
!    HISTORY:
!      05/01/2010  Fengyan Shi
!      05/06/2017  Young-Kwang Choi 
!-------------------------------------------------------------------------------------

SUBROUTINE PutFile(FILE_NAME,PHI)
      USE GLOBAL
      USE PARALLEL_FIELD_IO
      IMPLICIT NONE

      CHARACTER(LEN=80) FILE_NAME
      REAL(SP),DIMENSION(Mloc,Nloc),INTENT(IN) :: PHI

      CHARACTER(LEN=80)::TMP_NAME=' '

      SELECT CASE (TRIM(FIELD_IO_TYPE))
      CASE ('ASCII' , 'ascii')
            CALL PutFileASCII(FILE_NAME,PHI)
      CASE ('BINARY' , 'binary' )
            Call PutFileBinary(FILE_NAME,PHI)
      CASE DEFAULT
            !Defaults to ASCII case for non-valid input
            CALL PutFileASCII(FILE_NAME,PHI)
      END SELECT

END SUBROUTINE Putfile








