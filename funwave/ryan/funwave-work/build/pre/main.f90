










Program FUNWAVE_TVD
    ! Use necessary modules
         USE GLOBAL
         IMPLICIT NONE
    
    ! If using parallel computing, use MPI_INIT
          CALL MPI_INIT ( ier )
    

    ! Get inputs from `input.txt` 
         CALL READ_INPUT ! from `io.F`
    ! Set up indexing for MPI code 
         CALL INDEX ! from `misc.F`
    ! Inititialization of variables
         CALL ALLOCATE_VARIABLES ! from `init.F`
         CALL INITIALIZATION ! from `init.F`
    
    
    
   ! [TIC] Start clock 
         if(myid == 0) tbegin = MPI_Wtime( )
    
   ! Loop through times
       DO WHILE (TIME<TOTAL_TIME)
    
          ! Get output
          CALL OUTPUT ! from `io.F`
    
    ! update three variables
         Eta0=Eta
         Ubar0=Ubar
         Vbar0=Vbar  
    
         CALL EXCHANGE ! from `bc.F` 
    ! Estimate time stpe     
         CALL ESTIMATE_DT(Mloc,Nloc,DX,DY,U,V,H,MinDepthFrc,DT,CFL,TIME) ! from `misc.F`
      
    ! U0, V0 are moved to following part due to computation of Ut, Vt.
        U0=U   !ykchoi(15. 08. 06.)
        V0=V   !ykchoi
    
         ! Runge Kutta Time Stepping
         DO ISTAGE=1,3
           ! Calculate dispersion
           IF(DISPERSION)THEN
             CALL Cal_Dispersion
           ENDIF 
    
           CALL FLUXES ! from `fluxes.F` 
           CALL SourceTerms  ! from `sources.F`
           CALL ESTIMATE_HUV(ISTAGE) ! from `etauv_solver.F`
    
          ! etascreen was added, update_mask was moved here from outside RK 
           CALL UPDATE_MASK ! from `masks.F`
           CALL WAVE_BREAKING ! from `breaker.F`
           CALL EXCHANGE ! from `bc.F` 
           
           ! Calculate sponge effects
           IF(DIRECT_SPONGE)THEN
               CALL SPONGE_DAMPING ! from `sponge.F`
           ENDIF
         ENDDO
    

    
         CALL MIXING_STUFF ! from `mixing.F`
    
    
    !  find maximum eta velocity 
    
          IF (OUT_Hmax.OR.OUT_Hmin.OR.OUT_Umax.OR.OUT_MFmax.OR.OUT_VORmax.OR.OUT_Time)THEN
            CALL MAX_MIN_PROPERTY ! from misc.F
          ENDIF        
    
          CALL CHECK_BLOWUP ! from misc.F
      
       END DO
    

    
    !  [TOC] End clock
         if(myid.eq.0) tend = MPI_Wtime( )
    
    ! Report timing info
         if(myid.eq.0) write(*,*) 'Simulation takes',tend-tbegin,'seconds'
         if(myid.eq.0) write(3,*) 'Simulation takes',tend-tbegin,'seconds'
         if (myid.eq.0) WRITE(*,*)'Normal Termination!'
         if (myid.eq.0) WRITE(3,*)'Normal Termination!'
    
    ! Finish out mpi 
         call MPI_FINALIZE ( ier )
    
    END PROGRAM FUNWAVE_TVD
