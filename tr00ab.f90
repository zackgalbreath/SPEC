!> \defgroup grp_transform Rotational Transform
!>
!> \file
!> \brief Calculates rotational transform given an arbitrary tangential field.

!> \brief Calculates rotational transform given an arbitrary tangential field.
!> \ingroup grp_transform
!>
!> Calculates transform, \f$ \iota \hspace{-0.35em}\)-\( = \dot \theta ( 1 + \lambda_\theta) + \lambda_\zeta \f$, given \f${\bf B}|_{\cal I}\f$.
!>
!> **constructing straight field line angle on interfaces**
!>
!> <ul>
!> <li> The algorithm stems from introducing a straight field line angle \f$\theta_s=\theta+\lambda(\theta,\zeta)\f$, where
!>       \f{eqnarray}{ \lambda=\sum_j \lambda_{o,j}\sin(m_j\theta-n_j\zeta) + \sum_j \lambda_{e,j}\cos(m_j\theta-n_j\zeta)
!>       \f}
!>       and insisting that
!>       \f{eqnarray}{
!>       \frac{{\bf B}\cdot \nabla \theta_s}{{\bf B}\cdot \nabla \zeta} = \dot \theta ( 1 + \lambda_\theta) + \lambda_\zeta = {{\,\iota\!\!\!}-},
!>       \f}
!>       where \f${{\,\iota\!\!\!}-}\f$ is a constant that is to be determined. </li>
!> <li> Writing \f$\dot \theta = - \partial_s A_\zeta / \partial_s A_\theta\f$, we have
!>       \f{eqnarray}{ \label{eq:sfla_tr00ab}
!>       \partial_s A_\theta \, {{\,\iota\!\!\!}-} + \partial_s A_\zeta \, \lambda_\theta - \partial_s A_\theta \, \lambda_\zeta = - \partial_s A_\zeta
!>       \f} </li>
!> <li> Expanding this equation we obtain
!>       \f{eqnarray}{
!>         &   & \left( A_{\theta,e,k}^\prime \cos\alpha_k + A_{\theta,o,k}^\prime \sin\alpha_k\right) \, {{\,\iota\!\!\!}-} \nonumber \\
!>         & + & \left( A_{\zeta ,e,k}^\prime \cos\alpha_k + A_{\zeta ,o,k}^\prime \sin\alpha_k\right) \, \left( +m_j \lambda_{o,j} \cos\alpha_j - m_j \lambda_{e,j} \sin\alpha_j
!>               \right) \nonumber \\
!>         & - & \left( A_{\theta,e,k}^\prime \cos\alpha_k + A_{\theta,o,k}^\prime \sin\alpha_k\right) \, \left( -n_j \lambda_{o,j} \cos\alpha_j + n_j \lambda_{e,j} \sin\alpha_j
!>               \right) \nonumber \\
!>       = & - & \left( A_{\zeta ,e,k}^\prime \cos\alpha_k + A_{\zeta ,o,k}^\prime \sin\alpha_k\right),
!>       \f}
!>       where summation over \f$k=1,\,\f$\c mn and \f$j=2,\,\f$\c mns is implied </li>
!> <li> After applying double angle formulae,
!>       \f{eqnarray}{
!>         &   & \left( A_{\theta,e,k}^\prime \cos\alpha_k + A_{\theta,o,k}^\prime \sin\alpha_k\right) \, {{\,\iota\!\!\!}-} \nonumber \\
!>         & + & \lambda_{o,j} \left( + m_j A_{\zeta,e,k}^\prime + n_j A_{\theta,e,k}^\prime \right) \left[ +\cos(\alpha_k+\alpha_j)+\cos(\alpha_k-\alpha_j)\right]/2 \nonumber \\
!>         & + & \lambda_{e,j} \left( - m_j A_{\zeta,e,k}^\prime - n_j A_{\theta,e,k}^\prime \right) \left[ +\sin(\alpha_k+\alpha_j)-\sin(\alpha_k-\alpha_j)\right]/2 \nonumber \\
!>         & + & \lambda_{o,j} \left( + m_j A_{\zeta,o,k}^\prime + n_j A_{\theta,o,k}^\prime \right) \left[ +\sin(\alpha_k+\alpha_j)+\sin(\alpha_k-\alpha_j)\right]/2 \nonumber \\
!>         & + & \lambda_{e,j} \left( - m_j A_{\zeta,o,k}^\prime - n_j A_{\theta,o,k}^\prime \right) \left[ -\cos(\alpha_k+\alpha_j)+\cos(\alpha_k-\alpha_j)\right]/2 \nonumber \\
!>       = & - & \left( A_{\zeta,e,k}^\prime \cos\alpha_k + A_{\zeta,o,k}^\prime \sin\alpha_k\right),
!>       \f}
!>       and equating coefficients, an equation of the form \f${\bf A} \cdot {\bf x} = {\bf b}\f$ is obtained, where
!>       \f{eqnarray}{ {\bf x} = ( \underbrace{{{\,\iota\!\!\!}-}}_{\verb!x[1]!} \; , \;
!>                       \underbrace{\lambda_{o,2}, \lambda_{o,3},\dots}_{\verb!x[  2: N  ]!} \; , \;
!>                       \underbrace{\lambda_{e,2}, \lambda_{e,3},\dots}_{\verb!x[N+1:2N-1]!} \;
!>                      )^T.
!>       \f} </li>
!> </ul>
!>
!> **alternative iterative method**
!>
!> <ul>
!> <li> Consider the equation \f$\dot \theta ( 1 + \lambda_\theta ) + \lambda_\zeta = {{\,\iota\!\!\!}-}\f$, where \f$\lambda = \sum_j \lambda_j \sin\alpha_j\f$, given on a grid
!>       \f{eqnarray}{ \dot \theta_i + \dot \theta_i \sum_j m_j \cos \alpha_{i,j} \lambda_j - \sum_j n_j \cos \alpha_{i,j} \lambda_j = {{\,\iota\!\!\!}-},
!>       \f}
!>       where \f$i\f$ labels the grid point. </li>
!> <li> This is a matrix equation... </li>
!> </ul>
!>
!> @param lvol
!> @param mn
!> @param NN
!> @param Nt
!> @param Nz
!> @param iflag
!> @param ldiota
subroutine tr00ab( lvol, mn, NN, Nt, Nz, iflag, ldiota ) ! construct straight-field line magnetic coordinates;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  use constants, only : zero, third, half, one, two, pi2, goldenmean

  use numerical, only : vsmall, small, machprec, sqrtmachprec

  use fileunits, only : ounit

  use inputlist, only : Wmacros, Wtr00ab, Nvol, Lrad, Mpol, Ntor, &
                        Lsparse, Lsvdiota, imethod, iorder, iprecon, iotatol

  use cputiming, only : Ttr00ab

  use allglobal, only : ncpu, cpus, myid, MPI_COMM_SPEC, &
                        pi2nfp, &
                        Mvol, im, in, mns, ims, ins, &
                        YESstellsym, NOTstellsym, &
                        glambda, & ! global lambda: initial guesses will be saved; 21 Apr 13;
                        Ntz, hNt, hNz, &
                        iotakkii, iotaksub, iotakadd, iotaksgn, &
                        Ate, Aze, Ato, Azo, TT, RTT, &
                        Lcoordinatesingularity, Lvacuumregion, regumm

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  LOCALS

  INTEGER, intent(in)  :: lvol, mn, NN, Nt, Nz, iflag

  REAL, intent(inout)  :: ldiota(0:1,-1:2)

  INTEGER              :: innout, ll, ii, jj, kk, jb, kb, mj, nj, ideriv, jderiv, id, MM, ielement, nelements, Lcurvature, idof, icon, mi, ni, imupf

  REAL                 :: lcpu, mfactor, lss, Dteta, Dzeta, rfac, tol, rnorm, omega, diotaerror!, sparsedenseerror

  REAL                 :: lAte(0:mn,-1:2), lAze(0:mn,-1:2), lAto(0:mn,-1:2), lAzo(0:mn,-1:2)

!  REAL                 :: lBso(1:mn,-1:2), lBte(1:mn,-1:2), lBze(1:mn,-1:2)
!  REAL                 :: lBse(1:mn,-1:2), lBto(1:mn,-1:2), lBzo(1:mn,-1:2)

!  REAL                 :: gvu(1:Nt*Nz,1:3,1:3) ! local workspace; 13 Sep 13;

! required for Fourier routines;
  INTEGER              :: IA, if04aaf, idgesvx, ipiv(1:NN), iwork4(1:NN)
  REAL  , allocatable  :: dmatrix(:,:,:), omatrix(:,:), FAA(:,:)
  REAL                 :: drhs(1:NN,-1:2), dlambda(1:NN,-1:2)
  REAL                 :: Rdgesvx(1:NN), Cdgesvx(1:NN), work4(1:4*NN), rcond, ferr(1), berr(1), ferr2(1:2), berr2(1:2)
  CHARACTER            :: equed

! required for real-space routines;
  INTEGER              :: maxitn, reqdits, extralength, lrwork, integerwork(1:2*Nt*Nz+2+1), if11def, if11zaf, if11xaf
  INTEGER              :: IAA, if04atf, if04arf
  INTEGER              :: Ndof, label(-3:Nt+2,-3:Nz+2), isym

!required for SVD routines;
  INTEGER              :: idgelsd, Lwork, Liwork, Irank, nlvl
  REAL                 :: sval(1:NN)
  REAL   , allocatable :: work(:)

  REAL                 ::                      Bsupt(1:Nt*Nz,-1:2), Bsupz(1:Nt*Nz,-1:2), tdot(1:Nt*Nz)
  REAL                 :: Bsubs(1:Nt*Nz,-1:2), Bsubt(1:Nt*Nz,-1:2), Bsubz(1:Nt*Nz,-1:2)

  REAL                 :: dotteta, dotzeta

  REAL   , allocatable :: rmatrix(:,:,:), rrhs(:,:), rlambda(:,:), wks1(:), wks2(:), AA(:,:)

  INTEGER              :: inz(-1:2), lnz
  INTEGER, allocatable :: irow(:,:), jcol(:,:), istr(:), iwork(:)
  REAL   , allocatable :: smatrix(:,:), srhs(:,:), slambda(:,:), swork(:)
  CHARACTER            :: duplicate*1, zeros*1, method*8, precon*1, trans*1, check*1 ! logical control of sparse routines; 20 Apr 13;

  BEGIN(tr00ab)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

#ifdef DEBUG
  FATAL( tr00ab, mns.le.0, no degrees of freedom in angle transformation ) ! this is only for Fourier; 20 Apr 13;
  FATAL( tr00ab, lvol.lt.1 .or. lvol.gt.Mvol, illegal lvol )
  FATAL( tr00ab, iflag.lt.-1 .or. iflag.gt.2, illegal iflag )
#endif

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  do innout = 0, 1 ! loop over inner and outer interfaces;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   if( Lcoordinatesingularity .and. innout.eq.0 ) cycle ! transform on coordinate    axis     is not required              ; 20 Apr 13;
   if( Lvacuumregion          .and. innout.eq.1 ) cycle ! transform on computational boundary is not required (not defined); 20 Apr 13;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   lAte(0:mn,-1:2) = zero ! radial derivatives of vector potential evaluated at interfaces; 20 Apr 13;
   lAze(0:mn,-1:2) = zero
!  if( NOTstellsym ) then ! the non-stellarator-symmetric harmonics need to be set to zero in any case; 20 Apr 13;
   lAto(0:mn,-1:2) = zero
   lAzo(0:mn,-1:2) = zero
!  endif

   do ideriv = -1, 2 ; id = ideriv ! labels derivative of magnetic field wrt enclosed fluxes; 20 Apr 13;

    if( iflag.eq. 1 .and. ideriv.ne.0 ) cycle ! derivatives of transform                                                        are not required; 20 Jun 14;
    if( iflag.eq. 2 .and. ideriv.lt.0 ) cycle ! derivatives of transform wrt geometry                                           is  not required; 20 Jun 14;
    if( iflag.eq.-1 .and. ideriv.gt.0 ) cycle ! derivatives of transform wrt helicity multiplier and differential poloidal flux are not required; 20 Jun 14;

    do ii = 1, mn ! loop over Fourier harmonics; 20 Apr 13;

     mi = im(ii)

     if (Lcoordinatesingularity) then
      do ll = mi, Lrad(lvol), 2 ! loop over Zernike polynomials; 01 Jul 19;

        ;lAte(ii,id) = lAte(ii,id) + Ate(lvol,id,ii)%s(ll) * RTT(ll,mi,innout,1) * half
        ;lAze(ii,id) = lAze(ii,id) - Aze(lvol,id,ii)%s(ll) * RTT(ll,mi,innout,1) * half
        if( NOTstellsym ) then
        lAto(ii,id) = lAto(ii,id) + Ato(lvol,id,ii)%s(ll) * RTT(ll,mi,innout,1) * half
        lAzo(ii,id) = lAzo(ii,id) - Azo(lvol,id,ii)%s(ll) * RTT(ll,mi,innout,1) * half
        endif

      enddo ! end of do ll; 30 Jan 13;
     else
      do ll = 0, Lrad(lvol) ! loop over Chebyshev polynomials; 20 Apr 13;

        ;lAte(ii,id) = lAte(ii,id) + Ate(lvol,id,ii)%s(ll) * TT(ll,innout,1) ! compute radial derivative of vector potential; 20 Apr 13;
        ;lAze(ii,id) = lAze(ii,id) - Aze(lvol,id,ii)%s(ll) * TT(ll,innout,1)
        if( NOTstellsym ) then
        lAto(ii,id) = lAto(ii,id) + Ato(lvol,id,ii)%s(ll) * TT(ll,innout,1)
        lAzo(ii,id) = lAzo(ii,id) - Azo(lvol,id,ii)%s(ll) * TT(ll,innout,1)
        endif

      enddo ! end of do ll; 30 Jan 13;
     end if ! Lcoordinatesingularity; 01 Jul 19;
    enddo ! end of do ii; 30 Jan 13; ! Fourier harmonics, and their derivatives, have been constructed; 20 Apr 13;

    if( Lsparse.gt.0 ) then ! will construct transformation to straight-field line angle in real space; 24 Apr 13;
     call invfft( mn, im(1:mn), in(1:mn), lAte(1:mn,id), lAto(1:mn,id), lAze(1:mn,id), lAzo(1:mn,id), &
                  Nt, Nz, Bsupz(1:Ntz,id), Bsupt(1:Ntz,id) ) ! map to real space;
    endif

   enddo ! end of do ideriv; 31 Jan 13;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

! construct real-space, real-space transformation matrix; 20 Apr 13;

   if( Lsparse.eq.0 .or. Lsparse.eq.3 ) then
    SALLOCATE( dmatrix, (1:NN,1:NN,-1:2), zero )
    SALLOCATE( omatrix, (1:NN,1:NN), zero )
    SALLOCATE( FAA, (1:NN,1:NN), zero )
   endif


#ifdef LSPARSE

   if( Lsparse.gt.0 ) then

    FATAL( tr00ab, NOTstellsym, under construction )
    FATAL( tr00ab, Ntor.ne.0  , under construction )

    select case( iorder )
    case( 2 ) ; Dteta =  2 * pi2 / Nt ; Dzeta = pi2nfp / Nz ! real-space grid resolution; 20 Apr 13;
    case( 4 ) ; Dteta = 12 * pi2 / Nt ; Dzeta = pi2nfp / Nz ! real-space grid resolution; 20 Apr 13;
    case( 6 ) ; Dteta = 60 * pi2 / Nt ; Dzeta = pi2nfp / Nz ! real-space grid resolution; 20 Apr 13;
    case default
     FATAL( tr00ab, .true., iorder not supported )
    end select

    tdot(1:Ntz) = Bsupt(1:Ntz,0) / Bsupz(1:Ntz,0) ! shorthand; 24 Apr 13;


    label(-3:Nt+2,-3:Nz+2) = 0 ! default; 23 Apr 13;

    if( YESstellsym ) then

     if( Ntor.eq.0 ) Ndof = ( hNt - 1)                                 ! total number of independent degrees of freedom in real-space angle transformation;
     if( Ntor.gt.0 ) Ndof = ( hNt - 1) + Nt * ( hNz - 1 ) + (hNt - 1 ) ! total number of independent degrees of freedom in real-space angle transformation;

     ii = 0 ! will label independent degrees of freedom in real space lambda; 23 Apr 13;

     do kk = 0, hNz ! hNz & hNt are set in preset;
      do jj = 0, hNt

       if( jj.eq.0   .and. kk.eq.0   ) cycle
       if( jj.eq.hNt .and. kk.eq.0   ) cycle
!      if( jj.eq.0   .and. kk.eq.hNz ) cycle
!      if( jj.ge.hNt .and. kk.eq.hNz ) cycle

       ii = ii + 1 ; label(jj,kk) = ii ! labels degree of freedom; 24 Apr 13;

      enddo ! end of do jj; 23 Apr 13;
     enddo ! end of do kk; 23 Apr 13;

    else ! will not assume stellarator symmetry; 24 Apr 13;

    endif

    FATAL( tr00ab, ii.ne.Ndof, counting error )

    Ndof = Ndof + 1 ! include rotational-transform as a degree-of-freedom; 23 Apr 13;

! dense arrays; 24 Apr 13; ! these will eventually be redundant; 24 Apr 13;
    if( Lsparse.eq.1 ) then ! dense transformation; 24 Apr 13;
     SALLOCATE( rmatrix, (1:Ndof,1:Ndof,-1:2), zero ) ! real-space angle transformation matrix; dense; 23 Apr 13;
     SALLOCATE( rrhs   , (1:Ndof,       -1:2), zero )
     SALLOCATE( rlambda, (1:Ndof,       -1:2), zero )
     SALLOCATE( wks1   , (1:Ndof            ), zero )
     SALLOCATE( wks2   , (1:Ndof            ), zero )
     SALLOCATE( AA     , (1:Ndof,1:Ndof     ), zero )
    endif ! end of if( Lsparse.eq.1 ) ; 24 Apr 13;

! sparse arrays; ! all of these can be simply defined (1:Ntz) etc. . . . ; 24 Apr 13;
    if( Lsparse.ge.2 ) then ! sparse transformation; 24 Apr 13;
     SALLOCATE( srhs   , (1:  Ndof  ,-1:2), zero )
     SALLOCATE( istr   , (1:  Ndof+1     ),   0  ) ! for re-ordering; 24 Apr 13;
     SALLOCATE( iwork  , (1:2*Ndof+1     ),   0  ) ! for re-ordering & iterative solver; 24 Apr 13;
     SALLOCATE( slambda, (1:  Ndof  ,-1:2), zero )
     select case( iorder )
     case( 2 )
      SALLOCATE( smatrix, (1:Ndof*5,-1:2), zero) ! real-space angle transformation; sparse; 24 Apr 13;
      SALLOCATE( irow   , (1:Ndof*5,-1:2),   0 )
      SALLOCATE( jcol   , (1:Ndof*5,-1:2),   0 )
     case default
      FATAL( tr00ab, .true., need to estimate length of smatrix irow and jcol )
     end select
    endif ! end of if( Lsparse.gt.2 ) ; 24 Apr 13;

    do ideriv = -1, 2 ; id = ideriv ! loop over derivatives wrt enclosed fluxes/currents; 20 Apr 13;

     if( iflag.eq. 1 .and. ideriv.ne.0 ) cycle
     if( iflag.eq. 2 .and. ideriv.lt.0 ) cycle
     if( iflag.eq.-1 .and. ideriv.gt.0 ) cycle

    !if( Lscalarpotential .and. ideriv.eq.2 ) cycle ! do not need derivatives of transform wrt enclosed poloidal current = "linking current" provided by coils;

     lnz=0 ! counter; 24 Apr 13;

     do kk = 0, Nz-1 ! this is over the full domain; 24 Apr 13;
      do jj = 0, Nt-1 ! this is over the full domain; 24 Apr 13;

       ii = 1 + jj + kk * Nt ! labels grid point; 24 Apr 13;

       icon = label(jj,kk) ! labels constraint = row; 23 Apr 13;

       if( icon.eq.0 ) cycle ! this is not a degree of freedom; 23 Apr 13;

       if( ideriv.eq.0 ) then ; dotteta =                  tdot(ii)                                 ; dotzeta = one
       else                   ; dotteta = ( Bsupt(ii,id) - tdot(ii) * Bsupz(ii,id) ) / Bsupz(ii, 0) ; dotzeta = zero
       endif

       if( Lsparse.eq.1 ) rrhs(icon,id) = rrhs(icon,id) - dotteta
       if( Lsparse.ge.2 ) srhs(icon,id) = srhs(icon,id) - dotteta

       if( Ntor.eq.0 .and. iorder.eq.2 ) nelements = 2 ! will use second order difference approximation; 24 Apr 13;
       if( Ntor.eq.0 .and. iorder.eq.4 ) nelements = 4 ! will use fourth order difference approximation; 24 Apr 13;
       if( Ntor.eq.0 .and. iorder.eq.6 ) nelements = 6 ! will use sixth  order difference approximation; 24 Apr 13;

       do ielement = 1, nelements

        select case( iorder )
        case( 2 ) ! order of finite-difference estimate of derivative; 24 Apr 13;
         select case( ielement )
         case( 1 ) ; jb = jj+1 ; kb = kk   ; rfac = +  1 * dotteta / Dteta ; isym = +1
         case( 2 ) ; jb = jj-1 ; kb = kk   ; rfac = -  1 * dotteta / Dteta ; isym = +1
         end select
        case( 4 ) ! order of finite-difference estimate of derivative; 24 Apr 13;
         select case( ielement ) ! finite difference estimate of derivatives; 23 Apr 13;
         case( 1 ) ; jb = jj+2 ; kb = kk   ; rfac = -  1 * dotteta / Dteta ; isym = +1
         case( 2 ) ; jb = jj+1 ; kb = kk   ; rfac = +  8 * dotteta / Dteta ; isym = +1
         case( 3 ) ; jb = jj-1 ; kb = kk   ; rfac = -  8 * dotteta / Dteta ; isym = +1
         case( 4 ) ; jb = jj-2 ; kb = kk   ; rfac = +  1 * dotteta / Dteta ; isym = +1
         end select
        case( 6 ) ! order of finite-difference estimate of derivative; 24 Apr 13;
         select case( ielement ) ! finite difference estimate of derivatives; 23 Apr 13;
         case( 1 ) ; jb = jj+3 ; kb = kk   ; rfac = +  1 * dotteta / Dteta ; isym = +1
         case( 2 ) ; jb = jj+2 ; kb = kk   ; rfac = -  9 * dotteta / Dteta ; isym = +1
         case( 3 ) ; jb = jj+1 ; kb = kk   ; rfac = + 45 * dotteta / Dteta ; isym = +1
         case( 4 ) ; jb = jj-1 ; kb = kk   ; rfac = - 45 * dotteta / Dteta ; isym = +1
         case( 5 ) ; jb = jj-2 ; kb = kk   ; rfac = +  9 * dotteta / Dteta ; isym = +1
         case( 6 ) ; jb = jj-3 ; kb = kk   ; rfac = -  1 * dotteta / Dteta ; isym = +1
         end select
        case default
         FATAL( tr00ab, .true., selected value of iorder not supported )
        end select ! end of select case( iorder ) ; 24 Apr 13;

        if    ( jb.eq.-3       ) then ; jb = 3       ; isym = -1
        elseif( jb.eq.-2       ) then ; jb = 2       ; isym = -1
        elseif( jb.eq.-1       ) then ; jb = 1       ; isym = -1
        elseif( jb.eq. 1 + hNt ) then ; jb = hNt - 1 ; isym = -1
        elseif( jb.eq. 2 + hNt ) then ; jb = hNt - 2 ; isym = -1
        elseif( jb.eq. 3 + hNt ) then ; jb = hNt - 3 ; isym = -1
        endif

        idof = label(jb,kb) ! labels degree of freedom = column; 23 Apr 13;

        if( idof.eq.0 ) cycle ! not a degree of freedom; 23 Apr 13;

        if( Lsparse.eq.1 ) rmatrix(icon,idof,id) = rmatrix(icon,idof,id) + rfac * isym
        if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id) = rfac * isym ; irow(lnz,id) = icon ; jcol(lnz,id) = idof
        endif

       enddo ! end of do ielement; 20 Apr 13;

       if( Lsparse.eq.1 ) rmatrix(icon,Ndof,id) = rmatrix(icon,Ndof,id) - dotzeta
       if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id) = -dotzeta    ; irow(lnz,id) = icon ; jcol(lnz,id) = Ndof
       endif

      enddo ! end of do jj; 20 Apr 13;
     enddo ! end of do kk; 20 Apr 13;


     jj =  0  ; kk = 0 ! origin; now consider rotational-transform as degree of freedom; 24 Apr 13;

     ii = 1 + jj + kk*Nt

     icon = Ndof ! not used; 24 Apr 13;

     if( ideriv.eq.0 ) then ; dotteta =                  tdot(ii)                                 ; dotzeta = one
     else                   ; dotteta = ( Bsupt(ii,id) - tdot(ii) * Bsupz(ii,id) ) / Bsupz(ii, 0) ; dotzeta = zero
     endif

     if( Lsparse.eq.1 ) rrhs(Ndof,id) = rrhs(Ndof,id) - dotteta
     if( Lsparse.ge.2 ) srhs(Ndof,id) = srhs(Ndof,id) - dotteta

     select case( iorder )
     case( 2 )
      rfac=2*(+ 1)*dotteta/Dteta
      if( Lsparse.eq.1 ) rmatrix(Ndof,   1,id)=rmatrix(Ndof,   1,id)+rfac
      if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id)=rfac ; irow(lnz,id)=Ndof ; jcol(lnz,id)=   1
      endif

     case( 4 )
      rfac=2*(+ 8)*dotteta/Dteta
      if( Lsparse.eq.1 ) rmatrix(Ndof,   1,id)=rmatrix(Ndof,   1,id)+rfac
      if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id)=rfac ; irow(lnz,id)=Ndof ; jcol(lnz,id)=   1
      endif

      rfac=2*(- 1)*dotteta/Dteta
      if( Lsparse.eq.1 ) rmatrix(Ndof,   2,id)=rmatrix(Ndof,   2,id)+rfac
      if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id)=rfac ; irow(lnz,id)=Ndof ; jcol(lnz,id)=   2
      endif

     case( 6 )
      rfac=2*(+45)*dotteta/Dteta
      if( Lsparse.eq.1 ) rmatrix(Ndof,   1,id)=rmatrix(Ndof,   1,id)+rfac
      if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id)=rfac ; irow(lnz,id)=Ndof ; jcol(lnz,id)=   1
      endif

      rfac=2*(- 9)*dotteta/Dteta
      if( Lsparse.eq.1 ) rmatrix(Ndof,   2,id)=rmatrix(Ndof,   2,id)+rfac
      if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id)=rfac ; irow(lnz,id)=Ndof ; jcol(lnz,id)=   2
      endif

      rfac=2*(+ 1)*dotteta/Dteta
      if( Lsparse.eq.1 ) rmatrix(Ndof,   3,id)=rmatrix(Ndof,   3,id)+rfac
      if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id)=rfac ; irow(lnz,id)=Ndof ; jcol(lnz,id)=   3
      endif

     case default
      FATAL( tr00ab, .true., iorder not supported )
     end select

     rfac=  (- 1)*dotzeta
     if( Lsparse.eq.1 ) rmatrix(Ndof,Ndof,id)=rmatrix(Ndof,Ndof,id)*rfac
     if( Lsparse.ge.2 ) then ; lnz=lnz+1 ; smatrix(lnz,id)=rfac ; irow(lnz,id)=Ndof ; jcol(lnz,id)=Ndof
     endif

! REAL MATRICES HAVE BEEN CONSTRUCTED; 24 Apr 13;

     inz(id) = lnz ! lnz is short-hand; 24 Apr 13;

     lcpu = GETTIME ! record time taken in F11DEF; 20 Apr 13;

     duplicate = 'S' ! duplicate = 'R' = remove, 'S' = sum  or 'F' = fatal ; 20 Apr 13;
     zeros     = 'K' ! zeros     = 'R' = remove, 'K' = keep or 'F' = fatal ; 20 Apr 13;
     if11zaf   =  1
     call F11ZAF( Ndof, inz(id), smatrix(1:inz(id),id), irow(1:inz(id),id), jcol(1:inz(id),id), duplicate, zeros, istr(1:Ndof+1), iwork(1:Ndof), if11zaf )

     cput = GETTIME
     select case( if11zaf )                                                                  !1234567890123456789012
     case( 0 )    ; if( Wtr00ab ) write(ounit,1000) myid, lvol, innout, id, if11zaf, cput-lcpu, "success ;             "
     case( 1 )    ;               write(ounit,1000) myid, lvol, innout, id, if11zaf, cput-lcpu, "input error ;         "
     case( 2 )    ;               write(ounit,1000) myid, lvol, innout, id, if11zaf, cput-lcpu, "row or column error ; "
     case( 3 )    ;               write(ounit,1000) myid, lvol, innout, id, if11zaf, cput-lcpu, "duplicate eq F error ;"
     case( 4 )    ;               write(ounit,1000) myid, lvol, innout, id, if11zaf, cput-lcpu, "zeros eq F error ;    "
     case default ;               FATAL( tr00ab, .true., illegal ifail returned by F11ZAF )
     end select

1000 format("tr00ab : ", 10x ," : myid=",i3," ; lvol=",i3," ; innout="i2" ; ideriv="i2" ; if11zaf="i2" ; time="f10.4" ; "a22)

    enddo ! end of do ideriv; 23 Apr 13;

! for safety, let's assume that the following NAG routines will destroy the provided matrices, so better keep a backup; 24 Apr 13;

    if( Lsparse.eq.1 ) rmatrix(1:Ndof,1:Ndof,-1) = rmatrix(1:Ndof,1:Ndof, 0)
    if( Lsparse.ge.2 ) then
     inz(-1)=inz( 0); smatrix(1:inz(-1),-1)=smatrix(1:inz( 0), 0); irow(1:inz(-1),-1)=irow(1:inz( 0), 0); jcol(1:inz(-1),-1)=jcol(1:inz( 0), 0)
    endif

    if( Lsparse.ge.2 ) then

     select case( iprecon )
     case( 0 )    ; precon='N' ; extralength = 0
     case( 1 )    ; precon='J' ; extralength = Ndof
     case( 2 )    ; precon='S' ; extralength = Ndof
     case default ; FATAL( tr00ab, .true., illegal iprecon )
     end select

     select case( imethod )
     case( 1 )    ; method='RGMRES'   ; MM = min( Ndof, 50) ; lrwork = 4 * Ndof + MM * ( MM + Ndof + 4 ) + extralength + 1
     case( 2 )    ; method='CGS'      ;                     ; lrwork = 8 * Ndof + extralength
     case( 3 )    ; method='BICGSTAB' ; MM = min( Ndof, 10) ; lrwork = 2 * Ndof * ( MM + 2) + MM * ( MM + 2 ) + Ndof + 2 * extralength
     case default ; FATAL( tr00ab, .true., illegal imethod )
     end select

     SALLOCATE( swork, (1:lrwork), zero )

     tol = max( iotatol, machprec ) ; maxitn = Ndof**3 ; omega = one

    endif ! end of if( Lsparse.ge.2 ) ; 24 Apr 13;

    do ideriv = -1, 2 ; id = ideriv

     if( iflag.eq. 1 .and. ideriv.ne.0 ) cycle
     if( iflag.eq. 2 .and. ideriv.lt.0 ) cycle
     if( iflag.eq.-1 .and. ideriv.gt.0 ) cycle

    !if( Lscalarpotential .and. ideriv.eq.2 ) cycle ! do not need derivatives of transform wrt enclosed poloidal current = "linking current" provided by coils;

     if( Lsparse.eq.1 ) rmatrix(1:Ndof,1:Ndof, 0) = rmatrix(1:Ndof,1:Ndof,-1) ! recover original;
     if( Lsparse.ge.2 ) then
      inz( 0)=inz(-1); smatrix(1:inz( 0), 0)=smatrix(1:inz(-1),-1); irow(1:inz( 0), 0)=irow(1:inz(-1),-1); jcol(1:inz( 0), 0)=jcol(1:inz(-1),-1)
     endif

     select case( ideriv ) ! construct right-hand-sides; perturbed matrix calculation; 20 Apr 13;
     case( 0   )
     case( 1:2 ) ! matrix perturbation: A . \delta x = \delta b - \delta A . x ; 21 Apr 13;

      if( Lsparse.eq.1 ) rrhs(1:Ndof,id) = rrhs(1:Ndof,id) - matmul( rmatrix(1:Ndof,1:Ndof,id), rlambda(1:Ndof, 0) )

      if( Lsparse.ge.2 ) then
       trans = 'N' ! trans='N' for y=Ax; or trans='T' for y=A^T x; 20 Apr 13;
       check = 'C' ! check='C' to check; or check='N' for no checking N, NNZ, IROW and ICOL; 20 Apr 13; after debugging perhaps set check='N';
       if11xaf = 1
       call F11XAF( trans, Ndof, inz(id), smatrix(1:inz(id),id), irow(1:inz(id),id), jcol(1:inz(id),id), check, slambda(1:Ndof, 0), srhs(1:Ndof,-1), if11xaf )
       select case( if11xaf )                                                       !1234567890123
       case( 0 )    ; if( Wtr00ab ) write(ounit,1015) myid, lvol, innout, id, if11xaf, "success ;    "
       case( 1 )    ;               write(ounit,1015) myid, lvol, innout, id, if11xaf, "input error ;"
       case( 2 )    ;               write(ounit,1015) myid, lvol, innout, id, if11xaf, "input error ;"
       case( 3 )    ;               write(ounit,1015) myid, lvol, innout, id, if11xaf, "input error ;"
       case default ;               FATAL( tr00ab, .true., illegal ifail returned from F11XAF )
       end select
1015   format("tr00ab : ", 10x ," : myid=",i3," ; lvol=",i3," ; innout="i2" ; ideriv="i2" ; if11xaf="i2" ;      "10x" ; "a13)
       srhs(1:Ndof,id) = srhs(1:Ndof,id) - srhs(1:Ndof,-1)
      endif ! end of if( Lsparse.ge.2. ) ; 24 Apr 13;
     case default
      FATAL( tr00ab, .true., invalid ideriv )
     end select ! end of select case( ideriv ) ; 21 Apr 13;

     if( Lsparse.ge.2 ) then ! use sparse solver; 24 Apr 13;

      slambda(1:Ndof,ideriv) = glambda(1:Ndof,ideriv,innout,lvol) ! initial guess provided                   ; 24 Apr 13;
      lcpu = GETTIME ! record time taken in F11DEF; 20 Apr 13;
      reqdits = 0 ; rnorm = -one ! sometimes, F11DEF can exit without these being set; 21 Apr 13;
      if11def = 1
      call F11DEF( method, precon, Ndof, inz( 0), smatrix(1:inz( 0), 0), irow(1:inz( 0), 0), jcol(1:inz( 0), 0), omega, srhs(1:Ndof,id), MM, tol, maxitn, &
                   slambda(1:Ndof,id), rnorm, reqdits, swork(1:lrwork), lrwork, iwork(1:2*Ndof+1), if11def)
      cput = GETTIME
      select case( if11def ) !                                                                             !12345678901234567
      case( 0 ) ; if( Wtr00ab ) write(ounit,1020) cput-cpus, myid, lvol, innout, id, if11def, cput-lcpu, "solved sparse ;  ", slambda(Ndof,id), reqdits, rnorm
      case( 1 ) ;               write(ounit,1020) cput-cpus, myid, lvol, innout, id, if11def, cput-lcpu, "input error ;    ", zero            , reqdits, rnorm
      case( 2 ) ;               write(ounit,1020) cput-cpus, myid, lvol, innout, id, if11def, cput-lcpu, "irow/jcol error ;", zero            , reqdits, rnorm
      case( 3 ) ;               write(ounit,1020) cput-cpus, myid, lvol, innout, id, if11def, cput-lcpu, "zero diagonal ;  ", zero            , reqdits, rnorm
      case( 4 ) ;               write(ounit,1020) cput-cpus, myid, lvol, innout, id, if11def, cput-lcpu, "reqd acc. fail ; ", zero            , reqdits, rnorm
      case( 5 ) ;               write(ounit,1020) cput-cpus, myid, lvol, innout, id, if11def, cput-lcpu, "reqd acc. fail ; ", zero            , reqdits, rnorm
      case( 6 ) ;               write(ounit,1020) cput-cpus, myid, lvol, innout, id, if11def, cput-lcpu, "serious error ;  ", zero            , reqdits, rnorm
      case default ;            FATAL( tr00ab, .true., illegal ifail returned by f11def )
      end select
1020  format("tr00ab : ",f10.2," ; myid=",i3," ; lvol=",i3," ; innout="i2" ; ideriv="i2" ; if11def="i2" ; time="f10.4" ; "a17,:" [d]iota="es17.09&
" ; its="i6" rnorm="es13.5" ;")
      ldiota(innout,ideriv) = slambda(Ndof,id) ! return intent out; 23 Apr 13;
      glambda(1:Ndof,id,innout,lvol) = slambda(1:Ndof,id) ! save solution to use as initial guess; 21 Apr 13;

     endif ! end of if( Lsparse.ge.2 ) ; 24 Apr 13;

     if( Lsparse.eq.1 ) then ! use dense-solver; 24 Apr 13;

      lcpu = GETTIME
      if04atf = 1 ; IA = Ndof ; IAA = Ndof
      call F04ATF( rmatrix(1:Ndof,1:Ndof, 0), IA, rrhs(1:Ndof,id), Ndof, rlambda(1:Ndof,id), AA(1:IAA,1:Ndof), IAA, wks1(1:Ndof), wks2(1:Ndof), if04atf )
      cput = GETTIME
      select case( if04atf ) !                                                                             !12345678901234567
      case( 0 )    ; if( Wtr00ab ) write(ounit,1025) cput-cpus, myid, lvol, innout, id, if04atf, cput-lcpu, "solved real ;    ", rlambda(Ndof,id)
      case( 1 )    ;               write(ounit,1025) cput-cpus, myid, lvol, innout, id, if04atf, cput-lcpu, "singular ;       "
      case( 2 )    ;               write(ounit,1025) cput-cpus, myid, lvol, innout, id, if04atf, cput-lcpu, "ill-conditioned ;"
      case( 3 )    ;               write(ounit,1025) cput-cpus, myid, lvol, innout, id, if04atf, cput-lcpu, "input error ;    "
      case default ;               FATAL( tr00ab, .true., illegal ifail returned by f04atf )
      end select
1025  format("tr00ab : ",f10.2," ; myid=",i3," ; lvol=",i3," ; innout="i2" ; ideriv="i2" ; if04atf="i2" ; time="f10.4" ; "a17,:" [d]iota="es17.09" ;")
      ldiota(innout,ideriv) = rlambda(Ndof,id) ! return intent out; 23 Apr 13;

     endif ! end of if( Lsparse.ge.2 ) ; 24 Apr 13;

    enddo ! end of do ideriv; 23 Apr 13;

    DALLOCATE(swork)

   endif ! end of if( Lsparse.gt.0 );

#endif

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   if( Lsparse.eq.0 .or. Lsparse.eq.3 ) then ! Fourier transformation; 24 Apr 13;

    drhs(1:NN,-1:2) = zero

    dmatrix(1:NN,1:NN,-1:2) = zero ! initialize summation; 30 Jan 13;

    do ideriv = -1, 2

     if( iflag.eq. 1 .and. ideriv.ne.0 ) cycle ! derivatives                                                        not required; 20 Jun 14;
     if( iflag.eq. 2 .and. ideriv.lt.0 ) cycle ! derivatives wrt helicity multiplier and differential poloidal flux are required; 20 Jun 14;
     if( iflag.eq.-1 .and. ideriv.gt.0 ) cycle ! derivative  wrt geometry                                               required; 20 Jun 14;
!$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(kk,ii,jj,mj,nj)
     do kk = 1, mn

      ii = iotakkii(kk)

      ;drhs(ii      ,ideriv) = + lAze(kk,ideriv)
      if( NOTstellsym .and. kk.gt.0 ) then
       drhs(ii+mns-1,ideriv) = + lAzo(kk,ideriv)
      endif

      ;dmatrix(ii      ,1,ideriv) = lAte(kk,ideriv)
      if( NOTstellsym .and. kk.gt.0 ) then
       dmatrix(ii+mns-1,1,ideriv) = lAto(kk,ideriv)
      endif

!#ifdef NEWIOTA ! 19 Sep 16;
!! perhaps a rigid shift in the angle does not change the rotational-transform; 02 Sep 14; ! 19 Sep 16;
!      do jj = 1, mns ; mj = ims(jj) ; nj = ins(jj) ! 02 Sep 14; ! 19 Sep 16;
!#else ! 19 Sep 16;
      do jj = 2, mns ; mj = ims(jj) ; nj = ins(jj) ! this seems to ignore the non-stellarator symmetric mode; 02 Sep 14;
!#endif ! 19 Sep 16;

       ii = iotakadd(kk,jj)

       if( ii.lt.1 ) cycle

!      FATAL( tr00ab,ii.gt.NN .or. jj.gt.NN, illegal subscript ) ! THIS CAN BE DELETED EVENTUALLY; 02 Sep 14;
!$OMP ATOMIC UPDATE
       dmatrix(ii      ,jj      ,ideriv) = dmatrix(ii      ,jj      ,ideriv) + ( - mj * lAze(kk,ideriv) + nj * lAte(kk,ideriv) ) * half
       if( NOTstellsym) then
        FATAL( tr00ab,ii+mns-1.lt.1 .or. ii+mns-1.gt.NN .or. jj+mns-1.lt.1 .or. jj+mns-1.gt.NN, illegal subscript ) ! THIS CAN BE DELETED EVENTUALLY;
!$OMP ATOMIC UPDATE
        dmatrix(ii+mns-1,jj      ,ideriv) = dmatrix(ii+mns-1,jj      ,ideriv) + ( - mj * lAzo(kk,ideriv) + nj * lAto(kk,ideriv) ) * half
!$OMP ATOMIC UPDATE
        dmatrix(ii      ,jj+mns-1,ideriv) = dmatrix(ii      ,jj+mns-1,ideriv) - ( + mj * lAzo(kk,ideriv) - nj * lAto(kk,ideriv) ) * half
!$OMP ATOMIC UPDATE
        dmatrix(ii+mns-1,jj+mns-1,ideriv) = dmatrix(ii+mns-1,jj+mns-1,ideriv) + ( + mj * lAze(kk,ideriv) - nj * lAte(kk,ideriv) ) * half
       endif

      enddo ! end of do jj; 30 Jan 13;


      do jj = 2, mns ; mj = ims(jj) ; nj = ins(jj)

       ii = iotaksub(kk,jj)

       if( ii.lt.1 ) cycle

       FATAL( tr00ab,ii.gt.NN .or. jj.gt.NN, illegal subscript ) ! THIS CAN BE DELETED EVENTUALLY; 02 Sep 14;
!$OMP ATOMIC UPDATE
       dmatrix(ii      ,jj      ,ideriv) = dmatrix(ii      ,jj      ,ideriv) + ( - mj * lAze(kk,ideriv) + nj * lAte(kk,ideriv) ) * half
       if( NOTstellsym) then
        FATAL( tr00ab,ii+mns-1.lt.1 .or. ii+mns-1.gt.NN .or. jj+mns-1.lt.1 .or. jj+mns-1.gt.NN, illegal subscript ) ! THIS CAN BE DELETED EVENTUALLY;
!$OMP ATOMIC UPDATE
        dmatrix(ii+mns-1,jj      ,ideriv) = dmatrix(ii+mns-1,jj      ,ideriv) + ( - mj * lAzo(kk,ideriv) + nj * lAto(kk,ideriv) ) * half * iotaksgn(kk,jj)
!$OMP ATOMIC UPDATE
        dmatrix(ii      ,jj+mns-1,ideriv) = dmatrix(ii      ,jj+mns-1,ideriv) + ( + mj * lAzo(kk,ideriv) - nj * lAto(kk,ideriv) ) * half
!$OMP ATOMIC UPDATE
        dmatrix(ii+mns-1,jj+mns-1,ideriv) = dmatrix(ii+mns-1,jj+mns-1,ideriv) - ( + mj * lAze(kk,ideriv) - nj * lAte(kk,ideriv) ) * half * iotaksgn(kk,jj)
       endif

      enddo ! end of do jj; 30 Jan 13;

     enddo ! end of do kk; 30 Jan 13;
!$OMP END PARALLEL DO
    enddo ! end of ideriv; 30 Jan 13;


! FOURIER MATRICES HAVE BEEN CONSTRUCTED; SAVE UNPERTURBED MATRIX AND UNPERTURBED SOLUTION; FOR FUTURE USE; 20 Jun 14;

    !omatrix(1:NN,1:NN) = dmatrix(1:NN,1:NN,0) ! original "unperturbed" matrix; 30 Jan 13;
    call DCOPY(NN*NN, dmatrix(1,1,0), 1, omatrix(1,1), 1) ! BLAS version 21 Jul 19

    do jderiv = 0, 1

     if( iflag.eq. 1 .and. jderiv.ne.0 ) cycle ! derivatives of rotational transform (wrt either enclosed-fluxes/currents/geometry) are not required;

     select case( jderiv )
     case( 0 ) ;!             drhs(1:NN, 0) = drhs(1:NN, 0)
     case( 1 ) ;
      !if( iflag.eq. 2) then ; drhs(1:NN, 1) = drhs(1:NN, 1) - matmul( dmatrix(1:NN,1:NN, 1), dlambda(1:NN,0) ) ! derivative wrt helicity multiplier        ;
      ! ;                    ; drhs(1:NN, 2) = drhs(1:NN, 2) - matmul( dmatrix(1:NN,1:NN, 2), dlambda(1:NN,0) ) ! derivative wrt differential poloidal flux ;
      !endif
      !if( iflag.eq.-1) then ; drhs(1:NN,-1) = drhs(1:NN,-1) - matmul( dmatrix(1:NN,1:NN,-1), dlambda(1:NN,0) ) ! derivative wrt geometry;
      !endif
      if( iflag.eq. 2) then ; call DGEMV('N',NN,NN,-one,dmatrix(1,1, 1),NN,dlambda(1,0),1,one,drhs(1, 1),1)     ! BLAS version 21 Jul 19
       ;                    ; call DGEMV('N',NN,NN,-one,dmatrix(1,1, 2),NN,dlambda(1,0),1,one,drhs(1, 2),1)     ! BLAS version 21 Jul 19
      endif
      if( iflag.eq.-1) then ; call DGEMV('N',NN,NN,-one,dmatrix(1,1,-1),NN,dlambda(1,0),1,one,drhs(1,-1),1)     ! BLAS version 21 Jul 19
      endif
     case default
      FATAL( tr00ab, .true., invalid jderiv )
     end select

     lcpu = GETTIME ! record time taken in dgesvx; 09 Nov 17;

     select case( Lsvdiota )

     case( 0 ) ! Lsvdiota = 0; use linear solver to invert linear equations that define the straight fieldline angle; 01 Jul 14;

      if04aaf = 1

      select case( jderiv )

      case( 0 ) ! Lsvdiota = 0; jderiv = 0; 02 Sep 14;

       MM = 1

       call dgesvx( 'N', 'N', NN, MM, dmatrix(1:NN,1:NN,0), NN, FAA(1:NN,1:NN), NN, ipiv(1:NN),  &
                 equed, Rdgesvx(1:NN), Cdgesvx(1:NN), drhs(1:NN,0:0), NN, dlambda(1:NN,0:0),    &
		 NN, rcond, ferr, berr, work4(1:4*NN), iwork4(1:NN), idgesvx )

       ;                 ldiota(innout,    0) = dlambda(1,  0) ! return intent out; 21 Apr 13;

      case( 1 ) ! Lsvdiota = 0; jderiv = 1; 02 Sep 14;

       MM = 2
       if( iflag.eq.-1 ) then ; drhs(1:NN, 1) = drhs(1:NN,-1)
        ;                     ; drhs(1:NN, 2) = zero
       endif

       !dmatrix(1:NN,1:NN,0) = omatrix(1:NN,1:NN) ! original "unperturbed" matrix; 30 Jan 13;
       call DCOPY(NN*NN, omatrix(1,1), 1, dmatrix(1,1,0), 1) ! BLAS version 21 Jul 19

       call dgesvx( 'N', 'N', NN, MM, dmatrix(1:NN,1:NN,0), NN, FAA(1:NN,1:NN), NN, ipiv(1:NN),    &
                   equed, Rdgesvx(1:NN), Cdgesvx(1:NN), drhs(1:NN,1:MM), NN, dlambda(1:NN,1:MM),    &
	           NN, rcond, ferr2(1:MM), berr2(1:MM), work4(1:4*NN), iwork4(1:NN), idgesvx )

       if( iflag.eq. 2 ) ldiota(innout, 1:2) = dlambda(1,1:2) ! return intent out; 21 Apr 13;
       if( iflag.eq.-1 ) ldiota(innout,-1  ) = dlambda(1,  1) ! return intent out; 21 Apr 13;

      case default

       FATAL( tr00ab, .true., invalid jderiv )

      end select ! end of select case jderiv; 02 Sep 14;

      cput = GETTIME

      select case( idgesvx )                                                                                           !12345678901234567
      case( 0   )    ; if( Wtr00ab ) write(ounit,1030) cput-cpus, myid, lvol, innout, id, "idgesvx", idgesvx, cput-lcpu, "solved Fourier ; ", dlambda(1,0)
      case( 1:  )    ;               write(ounit,1030) cput-cpus, myid, lvol, innout, id, "idgesvx", idgesvx, cput-lcpu, "singular ;       "
      case( :-1 )    ;               write(ounit,1030) cput-cpus, myid, lvol, innout, id, "idgesvx", idgesvx, cput-lcpu, "input error ;    "
      case default ;               FATAL( tr00ab, .true., illegal ifail returned by dgesvx )
      end select

      FATAL( tr00ab, idgesvx.ne.0, failed to construct straight-fieldline angle using dgesvx )

     case( 1 ) ! Lsvdiota = 1; use least-squares to invert linear equations that define the straight fieldline angle; 01 Jul 14;


!     Here Lwork = 12*N + 2*N*SMLSIZ + 8*N*NLVL + N*NRHS + (SMLSIZ+1)**2  and Liwork = (11+3*NLVL)*NN
!     where SMLSIZ=25 and NLVL = MAX( 0, INT( LOG_2( MIN( M,N )/(SMLSIZ+1) ) ) + 1 )
!     Warning: this could become insufficient in some cases and produce input error message; 12 Nov 17
      nlvl   = max(0, int(log( real(NN)/26 )/log(2.0D0))+1)
      Lwork  = (63+8*nlvl)*NN+676
      Liwork = max(1,11*NN+3*nlvl*NN)

      SALLOCATE( work, (1:Lwork), zero )
      if (allocated(iwork)) then
        DALLOCATE(iwork)
      endif
      SALLOCATE( iwork, (1:Liwork), zero )

      select case( jderiv )

      case( 0 ) ! Lsvdiota = 1; jderiv = 0; 02 Sep 14;

       dlambda(1:NN,0) = drhs(1:NN,0) ! on entry, rhs; on exit, solution; 20 Jun 14;

       call dgelsd( NN, NN, 1, dmatrix(1:NN,1:NN,0), NN, dlambda(1:NN,0), NN, sval(1:NN), rcond, Irank, &
                    work(1:Lwork), Lwork, iwork(1:Liwork), idgelsd )

       ldiota(innout,0) = dlambda(1,0)

      case( 1 ) ! Lsvdiota = 1; jderiv = 1; 02 Sep 14;

       if(     iflag.eq. 2 ) then
        do imupf = 1, 2
         dmatrix(1:NN,1:NN,0) = omatrix(1:NN,1:NN) ; dlambda(1:NN,imupf) = drhs(1:NN,imupf)

         call dgelsd( NN, NN, 1, dmatrix(1:NN,1:NN,0), NN, dlambda(1:NN,imupf), NN, sval(1:NN), rcond, Irank, &
                      work(1:Lwork), Lwork, iwork(1:Liwork), idgelsd )

         ldiota(innout,imupf) = dlambda(1,imupf)
        enddo
       elseif( iflag.eq.-1 ) then
        do imupf = -1, -1
         dmatrix(1:NN,1:NN,0) = omatrix(1:NN,1:NN) ; dlambda(1:NN,imupf) = drhs(1:NN,imupf)

         call dgelsd( NN, NN, 1, dmatrix(1:NN,1:NN,0), NN, dlambda(1:NN,imupf), NN, sval(1:NN), rcond, Irank, &
                      work(1:Lwork), Lwork, iwork(1:Liwork), idgelsd )

         ldiota(innout,imupf) = dlambda(1,imupf)
        enddo
       else
        FATAL( tr00ab, .true., invalid iflag )
       endif

      case default

       FATAL( tr00ab, .true., invalid jderiv )

      end select ! end of select case( jderiv) ; 02 Sep 14;

      DALLOCATE(work)

      cput = GETTIME

      select case( idgelsd )                                                                                           !12345678901234567
      case( 0   )    ; if( Wtr00ab)  write(ounit,1030) cput-cpus, myid, lvol, innout, id, "idgelsd", idgelsd, cput-lcpu, "solved Fourier ; ", dlambda(1,0)
      case( :-1 )    ;               write(ounit,1030) cput-cpus, myid, lvol, innout, id, "idgelsd", idgelsd, cput-lcpu, "input error ;    "
      case( 1:  )    ;               write(ounit,1030) cput-cpus, myid, lvol, innout, id, "idgelsd", idgelsd, cput-lcpu, "QR failed ;      "
      case default ;               FATAL( tr00ab, .true., illegal ifail returned by f04arf )
      end select

      FATAL( tr00ab, idgelsd.ne.0, failed to construct straight-fieldline angle using dgelsd )

      dmatrix(1:NN,1:NN, 0) = omatrix(1:NN,1:NN) ! original "unperturbed" matrix; 30 Jan 13;

      case default

       FATAL( tr00ab, .true., illegal Lsvdiota )

      end select ! end of select case( Lsvdiota ) ; 02 Sep 14;

1030 format("tr00ab : ",f10.2," ; myid=",i3," ; lvol=",i3," ; innout="i2" ; jderiv="i2" ; "a7"="i2" ; time="f10.4" ; "a17,:" [d]iota="es17.09" ;")

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

    enddo ! end of do jderiv; 31 Jan 13;

   endif ! end of if( Lsparse.eq.0 .or. Lsparse.eq.3 );

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

#ifdef LSPARSE

   if( Lsparse.eq.3                        ) then ! compare estimates for rotational-transform provided by Fourier method and real-space method;

    cput = GETTIME

    do ideriv = -1, 2 ; id = ideriv

     if( iflag.eq. 1 .and. ideriv.ne.0 ) cycle
     if( iflag.eq. 2 .and. ideriv.lt.0 ) cycle
     if( iflag.eq.-1 .and. ideriv.gt.0 ) cycle

    !if( Lscalarpotential .and. ideriv.eq.2 ) cycle ! do not need derivatives of transform wrt enclosed poloidal current = "linking current" provided by coils;

     ;                           diotaerror = zero
     if( if11def.eq.0          ) diotaerror = dlambda(1,id) - slambda(Ndof,id) ! error between Fourier estimate and real-space estimate; 21 Apr 13;

     if( if11def.eq.0 ) write(ounit,2000) cput-cpus, myid, lvol, innout, ideriv, iorder, if11def, dlambda(1,id), slambda(Ndof,id), diotaerror
     if( if11def.ne.0 ) write(ounit,2000) cput-cpus, myid, lvol, innout, ideriv, iorder, if11def, dlambda(1,id)

    enddo ! end of do ideriv; 20 Apr 13;

   endif ! end of if( Lsparse.eq.3 . . . ) ; 20 Apr 13;

2000 format("tr00ab : ",f10.2," : myid=",i3," ; lvol=",i3," ; innout="i2" ; ideriv="i2" ; "i2" ; compare ; if11def="i2" ; iota=["&
  es18.10" ,"es18.10" ] ; err="es10.02" ;")

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   if( Lsparse.eq.1 ) then
    DALLOCATE(rmatrix)
    DALLOCATE(rrhs)
    DALLOCATE(rlambda)
    DALLOCATE(wks1)
    DALLOCATE(wks2)
    DALLOCATE(AA)
   endif

   if( Lsparse.ge.2 ) then
    DALLOCATE(smatrix)
    DALLOCATE(srhs)
    DALLOCATE(irow)
    DALLOCATE(jcol)
    DALLOCATE(slambda)
    DALLOCATE(istr)
    DALLOCATE(iwork)
   endif

#endif

   if( Lsparse.eq.0 .or. Lsparse.eq.3 ) then
     DALLOCATE( dmatrix )
     DALLOCATE( omatrix )
     DALLOCATE( FAA )
   endif


!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  enddo ! end of do innout; 29 Jan 13;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  RETURN(tr00ab)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

end subroutine tr00ab

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
