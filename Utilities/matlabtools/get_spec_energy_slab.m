function W = get_spec_energy_slab(data,lv,ns,nt,nz)
 
%
% GET_SPEC_ENERGY_SLAB( DATA, LV, NS, NT, NZ )
% ============================================
%
% Calculates Plasma Magnetic Energy in volume lv in slab geometry 
%
% INPUT
% -----
%   -data      : must be produced by calling read_spec(filename)
%   -lv        : volume in which to calculate the energy (total energy for lvol=0)
%   -ns        : is the s-coordinate resolution 
%   -nt        : is the theta-coordinate resolution
%   -nz        : is the zeta-coordinate resolution
%
% OUTPUT
% ------
%   -W         : total energy 
%
% Note: Stellarator symmetry is assumed
%
% written by J.Loizu (2018)

Nvol = data.input.physics.Nvol;

W    = 0;

sarr = linspace(-1,1,ns);
tarr = linspace(0,2*pi,nt);
zarr = linspace(0,2*pi,nz);

if(lv==0)

 for lvol=1:Nvol

  modB = get_spec_modB(data,lvol,sarr,tarr,zarr);

  jac  = get_spec_jacobian_slab(data,lvol,sarr,tarr,zarr);

  F    = jac.*modB.^2;

  dW   = trapz(sarr,trapz(tarr,trapz(zarr,F,3),2));

  W    = W + 0.5*dW;

 end

else

  lvol = lv;

  modB = get_spec_modB(data,lvol,sarr,tarr,zarr);

  jac  = get_spec_jacobian_slab(data,lvol,sarr,tarr,zarr);

  F    = jac.*modB.^2;

  dW   = trapz(sarr,trapz(tarr,trapz(zarr,F,3),2));

  W    = W + 0.5*dW;

end


