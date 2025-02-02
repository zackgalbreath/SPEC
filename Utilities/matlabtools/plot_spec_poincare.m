function plot_spec_poincare(data,nz0,nfp,arr,newfig)

%
% PLOT_SPEC_POINCARE( DATA, NZ0, NFP, ARR, NEWFIG )
% =================================================
%
% Produces Poincare plots of the field lines on different sections (within one field period)
%
% INPUT    
% -----
%   -data     : must be produced by calling read_spec(fname)
%   -nz0      : shows the nz0 toroidal plane or equidistant planes (nz0=-1)
%   -nfp      : number of field periods
%   -arr      : step to skip field-line trajectories when ploting (arr=1 means all trajectories are ploted)
%             : can be an array of which field line should be plotted, if size(arra)>1
%   -newfig   : opens(=1) or not(=0) a new figure, or overwrites (=2) last plot
%
% written by J.Loizu (2015)
% modified by A.Baillod (2019)
% modified by J.Loizu (2020)

try
 rpol    = data.input.physics.rpol; % get size of slab
catch
 rpol    = 1;
end

nptraj   = size(data.poincare.R,1);   % # of poincare trajectories (field lines)

nz       = size(data.poincare.R,2);   % # of toroidal planes

flag2col = 'F';                     % flag for ploting field lines with alternating colour ('T') or not ('F')

ind = find(arr>nptraj);
if ~isempty(ind)
   error(['Index out of bound in arr. All elements should be smaller than ', num2str(nptraj)]) 
end

if length(arr) == 1
   arr = 1:arr:nptraj; 
end



disp(' ');
disp('Number of toroidal planes available: (one field period)');
nz
disp(' ');


rmax   = max(max(max(data.poincare.R)));
rmin   = min(min(min(data.poincare.R)));
zmax   = max(max(max(data.poincare.Z)));
zmin   = min(min(min(data.poincare.Z)));

switch data.input.physics.Igeometry
    case 1
        xmin =  0;
        xmax =  2*pi*rpol;
        ymin = -0.1;
        ymax =  data.output.Rbc(1,end)+0.1;
    case 2
        xmin = -1.1*rmax;
        xmax =  1.1*rmax;
        ymin = -1.1*rmax;
        ymax =  1.1*rmax;
    case 3
        xmin =  0.9*rmin;
        xmax =  1.1*rmax;
        ymin =  1.1*zmin;
        ymax =  1.1*zmax;
end


nth    = 5096;  %ploting options for the boundary
bcol   = 'r';
bthick = 3;
if(data.input.physics.Lfreebound==1)
bcol   = 'k';
bthick = 1;
end



if(flag2col=='T')
 pcol   = ['k' 'b'];
else
 pcol   = ['k' 'k'];
end

switch newfig
    case 0
        hold on
    case 1
        figure
        hold on
    case 2
        hold off
end

switch nz0

 case -1            

  npl = input('Number of planes: ');
  k   = 0;
  
  for j=1:nz/npl:nz  %for npl toroidal planes

   k = k+1;

   subplot(npl,1,k)
 
   switch data.input.physics.Igeometry
       case 1
           R    = squeeze(data.poincare.R(:,j,:));
           T    = rpol*mod(squeeze(data.poincare.t(:,j,:)),2*pi);
           for i=arr       %for each field line trajectory
               scatter(T(i,:),R(i,:),10,'.k')
               hold on
           end
       case 2  
           R    = squeeze(data.poincare.R(:,j,:));
           T    = squeeze(data.poincare.t(:,j,:));
           for i=arr       %for each field line trajectory
               scatter(R(i,:).*cos(T(i,:)),R(i,:).*sin(T(i,:)),10,'.k')
               hold on;
           end
       case 3
           R = squeeze(data.poincare.R(:,j,:));
           Z = squeeze(data.poincare.Z(:,j,:));
           for i=arr     %for each field line trajectory
            scatter(R(i,:),Z(i,:),10,'.k')
            hold on;
           end
       otherwise
           error('Unsupported geometry')
   end
   
   dth   = 2*pi/nth;
   theta = dth:dth:2*pi; 
   zeta  = (j-1)*(2*pi/nz)/nfp;

   switch data.input.physics.Igeometry
     case 1
       Xb  = rpol*theta;
       Yb1 = 0;
       Yb2 = 0;
       for imn=1:data.output.mn     % get and plot the boundary
         alpha = double(data.output.im(imn))*theta-double(data.output.in(imn))*zeta;
         Yb1   = Yb1   + data.output.Rbc(imn,1  )*cos(alpha) + data.output.Rbs(imn,1  )*sin(alpha);
         Yb2   = Yb2   + data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha);
       end
     case 2  
       Rb = 0;
       Zb = 0;
       for imn=1:data.output.mn     % get and plot the boundary
         alpha = double(data.output.im(imn))*theta-double(data.output.in(imn))*zeta;
         Rb = Rb + (data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha)).*cos(theta);
         Zb = Zb + (data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha)).*sin(theta);
       end
     case 3
       Rb = 0;
       Zb = 0;
       for imn=1:data.output.mn  % get and plot the boundary  % the data.output.in values go in steps of nfp
         alpha = double(data.output.im(imn))*theta-double(data.output.in(imn))*zeta;
         Rb    = Rb   + data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha);
         Zb    = Zb   + data.output.Zbs(imn,end)*sin(alpha) + data.output.Zbc(imn,end)*cos(alpha); 
       end
     otherwise
       error('Unsupported geometry')
   end  

  if data.input.physics.Igeometry ~= 1
   scatter(Rb,Zb,bthick,'*',bcol)
   hold on
   set(gca,'FontSize',12)
   axis equal
   xlabel('R','FontSize',12)
   ylabel('Z','FontSize',12)
  else
   scatter(Xb,Yb1,bthick,'*',bcol)
   scatter(Xb,Yb2,bthick,'*',bcol)
   hold on
   set(gca,'FontSize',12)
   xlabel('\theta r_{pol}','FontSize',12)
   ylabel('R','FontSize',12)
  end

  xlim([xmin xmax])
  ylim([ymin ymax])

 end

 otherwise  %if nz0>0
       
   switch data.input.physics.Igeometry
       case 1
           R    = squeeze(data.poincare.R(:,nz0,:));
           T    = rpol*mod(squeeze(data.poincare.t(:,nz0,:)),2*pi);
           for i=arr       %for each field line trajectory
               scatter(T(i,:),R(i,:),10,'.k')
               hold on
           end
       case 2  
           R    = squeeze(data.poincare.R(:,nz0,:));
           T    = squeeze(data.poincare.t(:,nz0,:));
           for i=arr       %for each field line trajectory
               scatter(R(i,:).*cos(T(i,:)),R(i,:).*sin(T(i,:)),10,'.k')
               hold on;
           end
       case 3
           R = squeeze(data.poincare.R(:,nz0,:));
           Z = squeeze(data.poincare.Z(:,nz0,:));
           for i=arr     %for each field line trajectory
            scatter(R(i,:),Z(i,:),10,'.k')
            hold on;
           end
       otherwise
           error('Unsupported geometry')
   end


  dth   = 2*pi/nth;
  theta = dth:dth:2*pi; 
  zeta  = (nz0-1.0)*(2.0*pi/nz)/double(nfp);
   
  
  switch data.input.physics.Igeometry
     case 1
       Xb  = rpol*theta;
       Yb1 = 0;
       Yb2 = 0;
       for imn=1:data.output.mn     % get and plot the boundary
         alpha = double(data.output.im(imn))*theta-double(data.output.in(imn))*zeta;
         Yb1    = Yb1   + data.output.Rbc(imn,1)*cos(alpha) + data.output.Rbs(imn,1)*sin(alpha);
         Yb2    = Yb2   + data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha);
       end
     case 2  
       Rb = 0;
       Zb = 0;
       for imn=1:data.output.mn     % get and plot the boundary
         alpha = double(data.output.im(imn))*theta-double(data.output.in(imn))*zeta;
         Rb = Rb + (data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha)).*cos(theta);
         Zb = Zb + (data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha)).*sin(theta);
       end
     case 3
       Rb = 0;
       Zb = 0;
       for imn=1:data.output.mn  % get and plot the boundary  % the data.output.in values go in steps of nfp
         alpha = double(data.output.im(imn))*theta-double(data.output.in(imn))*zeta;
         Rb    = Rb + data.output.Rbc(imn,end)*cos(alpha) + data.output.Rbs(imn,end)*sin(alpha);
         Zb    = Zb + data.output.Zbs(imn,end)*sin(alpha) + data.output.Zbc(imn,end)*cos(alpha); 
       end
     otherwise
       error('Unsupported geometry')
  end  

  if data.input.physics.Igeometry ~= 1
   scatter(Rb,Zb,bthick,'*',bcol)
   hold on
   set(gca,'FontSize',12)
   axis equal
   xlabel('R','FontSize',12)
   ylabel('Z','FontSize',12)
  else
   scatter(Xb,Yb1,bthick,'*',bcol)
   scatter(Xb,Yb2,bthick,'*',bcol)
   hold on
   set(gca,'FontSize',12)
   xlabel('\theta r_{pol}','FontSize',12)
   ylabel('R','FontSize',12)
  end

  xlim([xmin xmax])
  ylim([ymin ymax])

end


disp(' ');
disp('--- end of program ---');
disp(' ');
