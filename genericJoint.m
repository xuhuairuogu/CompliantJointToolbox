% GENERICJOINT Abstract generic base class for joint models.
%
% This class is abstract meaning that instances of this class cannot be
% instantiated. Only subclasses of GENERICJOINT can be instantiated.
%
% Notes::
%
%
% Examples::
%
%
% Author::
%  Joern Malzahn
%  Wesley Roozing
%
% See also jointBuilder.

% Copyright (C) 2016, by Joern Malzahn, Wesley Roozing
%
% This file is part of the Compliant Joint Toolbox (CJT).
%
% CJT is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% CJT is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
% License for more details.
%
% You should have received a copy of the GNU General Public License
% along with CJT. If not, see <http://www.gnu.org/licenses/>.
%
% For more information on the toolbox and contact to the authors visit
% <https://github.com/geez0x1/CompliantJointToolbox>

classdef genericJoint < handle
    
    properties
        verbose % verbose flag
        debug   % debug flag
    end
    
    properties (SetAccess = public)
        % Mechanical Properties
        % Inertiae
        m       % Actuator mass
        I_m     % Motor rotor inertia [kg m^2] (link side)
        I_g     % Motor-side gear inertia [kg m^2] (link side)
        I_b     % Torsion bar inertia [kg m^2] (link side)
        % Stiffnesses
        k_g     % Gearbox stiffness [Nm/rad]
        k_b     % Torsion bar stiffness [Nm/rad]
        % Linear viscous friction
        d_m     % Motor Damping [Nms/rad]
        d_g     % Gearbox damping [Nms/rad]
        d_b     % Torsion bar damping [Nms/rad]
        % Asymmetric viscous friction
        d_m_n   % Motor Damping - negative direction [Nms/rad]
        d_g_n   % Gearbox Damping - negative direction [Nms/rad]
        d_b_n   % Torsion bar damping - negative direction [Nms/rad]
        % Linear internal viscous friction
        d_mg    % Gearbox internal damping [Nms/rad]
        d_gb    % Torsion bar internal damping [Nms/rad]
        % Coulomb friction
        d_cm    % Motor Coulomb damping [Nm]
        d_cg    % Gearbox Coulomb damping [Nm]
        d_cb    % Torsion bar Coulomb damping [Nm]
        % Asymmetric Coulomb friction
        d_cm_n  % Motor Coulomb damping - negative direction [Nm]
        d_cg_n  % Gearbox Coulomb damping - negative direction [Nm]
        d_cb_n  % Torsion bar Coulomb damping - negative direction [Nm]
        % Cogging
        cog_a1	% Cosine amplitude [Nm]
        cog_a2	% Sine amplitude [Nm]
        cog_f	% Spatial frequency [periods/revolution]
        % Misc
        n       % Gear ratio []
        k_t     % Torque constant [Nm/A]
        r       % Armature resistance at normal ambient temperature [Ohm]
        x       % Armature inductance [H]
        Ts      % Sampling time [s]
        % Operating/max conditions
        v_0     % Operating [V]
        i_c     % Max. continuous current [A]
        i_p     % Peak current [A]
        dq_c    % Max. continuous speed (output)[rad/s]
        dq_p    % Max. peak speed (output) [rad/s]
        % Thermal parameters
        r_th1   % Thermal Resistance Windings to Housing [K/W]
        r_th2   % Thermal Resistance Housing to Air [K/W]
        T_thw   % Thermal Time Constant of the Windings [s]
        T_thm   % Thermal Time Constant of the Motor [s]
        Tmp_WMax % Maximum Armature Temperature [�C]
        Tmp_AMax % Maximum Ambient Temperature [�C]
        Tmp_AMin % Minimum Ambient Temperature [�C]
        Tmp_ANom % Normal Ambient Temperature [�C]
        
        % Desciptive Properties
        name                % Joint name
        paramName           % Parameter name
        modelName           % Model name
        nonlinearModelName  % Nonlinear model name
        
    end
    
    methods
        %__________________________________________________________________
        function this = genericJoint(params)
            % genericJoint Default constructor of the generic joint class.
            %
            %   gj = genericJoint(params)
            %
            % Inputs:
            %   params: parameter struct with fields corresponding to the
            %   genericJoint class parameters.
            %
            % Outputs:
            %   gj: the joint object gj.
            %
            % Notes::
            %   Since genericJoint is an abstract class, you can never manually
            %   call this constructor.
            %
            % Examples::
            %
            %
            % Author::
            %  Joern Malzahn
            %  Wesley Roozing
            %
            % See also jointBuilder.
            
            % Apply properties
            this.verbose    = params.verbose;
            this.debug      = params.debug;
            
            % Mechanical Properties
            % Inertiae
            this.m      = params.m;          % Actuator mass [kg]
            this.I_m    = params.I_m;        % Motor rotor inertia [kg m^2] (link side)
            this.I_g    = params.I_g;        % Motor-side gear inertia [kg m^2] (link side)
            this.I_b    = params.I_b;        % Torsion bar inertia [kg m^2] (link side)
            % Stiffnesses
            this.k_g    = params.k_g;        % Gearbox stiffness [Nm/rad]
            this.k_b    = params.k_b;        % Torsion bar stiffness [Nm/rad]
            % Linear viscous friction
            this.d_m    = params.d_m;        % Motor Damping [Nms/rad]
            this.d_g    = params.d_g;        % Gearbox damping [Nms/rad]
            this.d_b    = params.d_b;        % Torsion bar damping [Nms/rad]
            % Asymmetric viscous friction
            this.d_m_n  = params.d_m_n;      % Motor Damping - negative direction [Nms/rad]
            this.d_g_n  = params.d_g_n;      % Gearbox Damping - negative direction [Nms/rad]
            this.d_b_n  = params.d_b_n;      % Torsion bar damping - negative direction [Nms/rad]
            % Linear internal viscous friction
            this.d_mg   = params.d_mg;       % Gearbox internal damping [Nms/rad]
            this.d_gb   = params.d_gb;       % Torsion bar internal damping [Nms/rad]
            % Coulomb friction
            this.d_cm   = params.d_cm;       % Motor Coulomb damping [Nm]
            this.d_cg   = params.d_cg;       % Gearbox Coulomb damping [Nm]
            this.d_cb   = params.d_cb;       % Torsion bar Coulomb damping [Nm]
            % Asymmetric Coulomb friction
            this.d_cm_n = params.d_cm_n;     % Motor Coulomb damping - negative direction [Nm]
            this.d_cg_n = params.d_cg_n;     % Gearbox Coulomb damping - negative direction [Nm]
            this.d_cb_n = params.d_cb_n;     % Torsion bar Coulomb damping - negative direction [Nm]
            % Cogging
            this.cog_a1 = params.cog_a1;     % Cosine amplitude [Nm]
            this.cog_a2 = params.cog_a2;     % Sine amplitude [Nm]
            this.cog_f  = params.cog_f;      % Spatial frequency [periods/revolution]
            % Misc
            this.n      = params.n;          % Gear ratio []
            this.k_t    = params.k_t;        % Torque constant [Nm/A]
            this.r      = params.r;          % Armature resistance [Ohm]
            this.x      = params.x;          % Armature inductance [H]
            this.Ts     = params.Ts;         % Sampling time [s]
            % Operating/max conditions
            this.v_0    = params.v_0;        % Operating voltage [V]
            this.i_c    = params.i_c;        % Max. continuous current [A]
            this.i_p    = params.i_p;        % Peak stall current [A]
            this.dq_c   = params.dq_c;       % Max. continuous speed (output)[rad/s]
            this.dq_p   = params.dq_p;       % Max. peak speed (output) [rad/s]
            % Thermal parameters
            this.r_th1 = params.r_th1;       % Thermal Resistance Windings to Housing [K/W]
            this.r_th2 = params.r_th2;       % Thermal Resistance Housing to Air [K/W]
            this.T_thw = params.T_thw;       % Thermal Time Constant of the Windings [s]
            this.T_thm = params.T_thm;       % Thermal Time Constant of the Motor [s]
            this.Tmp_MMax = params.Tmp_MMax; % Maximum Armature Temperature [�C]
            this.Tmp_AMax = params.Tmp_AMax; % Maximum Ambient Temperature [�C]
            this.Tmp_AMin = params.Tmp_AMin; % Minimum Ambient Temperature [�C]
            this.Tmp_ANom = params.Tmp_ANom; % Normal Ambient Temperature [�C]
            
            % Desciptive Properties
            this.name               = params.name;                  % Joint descriptive name
            this.paramName          = params.paramName;             % Parameter name
            this.modelName          = params.modelName;             % Model name
            this.nonlinearModelName = params.nonlinearModelName;    % Nonlinear model name
        end
        
        
        %__________________________________________________________________
        
        function params = getParams(this)
            % GETPARAMS Return a struct with all joint parameters.
            %
            %   p = gj.getParams
            %
            % Inputs:
            %
            % Outputs:
            %   p: struct with fields identical to the parameters of the joint
            %      object gj.
            %
            % Notes::
            %
            %
            % Examples::
            %
            %
            % Author::
            %  Joern Malzahn
            %  Wesley Roozing
            %
            % See also genericJoint, jointBuilder.
            
            params  = struct;
            p       = properties(this);
            
            % Put all properties
            for iP = 1:numel(p);
                params.(p{iP}) = this.(p{iP});
            end
            
        end
        
        %__________________________________________________________________
        
        function sys = getStateSpace(obj)
            % GETSTATESPACE Get continuous time state-space representation of
            % the linear dynamics.
            %
            %   sys = gj.getStateSpace
            %
            % Inputs:
            %
            % Outputs:
            %   sys: continuous time state-space representation of the linear
            %   dynamics.
            %
            % Notes::
            %
            %
            % Examples::
            %
            %
            % Author::
            %  Joern Malzahn
            %  Wesley Roozing
            %
            % See also getStateSpaceD, genericJoint, jointBuilder.
            [A, B, C, ~, ~, ~]  = obj.getDynamicsMatrices();
            D                   = 0;
            sys                 = ss(A, B, C, D);
        end
        
        %__________________________________________________________________
        function sysd = getStateSpaceD(this)
            % GETSTATESPACE Get discrete time state-space representation of
            % the linear dynamics.
            %
            %   sys = gj.getStateSpaceD
            %
            % Inputs:
            %
            % Outputs:
            %   sys: discrete time state-space representation of the linear
            %   dynamics.
            %
            % Notes::
            %   The function automatically uses the sampling time specified by
            %   the object parameters.
            %   Beyond that, the function discretizes the continous time
            %   description of the dynamics. Therefore implicitly calls
            %   getStateSpace and c2d afterwards.
            %
            % TODO::
            %  - Optionally allow different c2d methods
            %  - Optionally allow different sampling times
            %  - In particular, allow for both existing discrete time state
            %    space descriptions.
            %
            %   Since there exist two generally different forms of discrete
            %   time state space models, the functionality should be improved
            %   to allow decisions for any of them made by the user.
            %
            % Examples::
            %
            %
            % Author::
            %  Joern Malzahn, (jorn.malzahn@iit.it)
            %  Wesley Roozing, (wesley.roozing@iit.it)
            %
            % See also getStateSpace, ss, c2d.
            
            sys     = this.getStateSpace();
            sysd    = c2d(sys, this.Ts, 'tustin');
        end
        
        %__________________________________________________________________
        function sys = getTF(obj)
            % GETTF Get continuous time transfer function representation of the
            % linear dynamics.
            %
            %   sys = gj.getTF
            %
            % Inputs:
            %
            % Outputs:
            %   sys: continuous time transfer function representation of the linear
            %   dynamics.
            %
            % Notes::
            %
            %
            % Examples::
            %
            %
            % Author::
            %  Joern Malzahn, jorn.malzahn@iit.it
            %  Wesley Roozing, wesley.roozing@iit.it
            %
            % See also getStateSpace, getTFd, genericJoint, jointBuilder.
            sys     = obj.getStateSpace();
            sys     = tf(sys);
        end
        
        %__________________________________________________________________
        function sysd = getTFd(obj)
            % GETTFD Get discrete time transfer function representation of the
            % linear dynamics.
            %
            %   sys = gj.getTFd
            %
            % Inputs:
            %
            % Outputs:
            %   sys: discrete time transfer function representation of the linear
            %   dynamics.
            %
            % Notes::
            %   This function calls getStateSpaceD and converts the resulting
            %   state space model into a transfer function. For details about
            %   the behavior please look at getStateSpaceD.
            %
            % Examples::
            %
            %
            % Author::
            %  Joern Malzahn, jorn.malzahn@iit.it
            %  Wesley Roozing, wesley.roozing@iit.it
            %
            % See also getStateSpaceD, getTFd, genericJoint, jointBuilder.
            sys     = obj.getStateSpaceD();
            sysd    = tf(sys);
        end
        
        
        %__________________________________________________________________
        function makeSym(obj)
            % MAKESYM Return a symbolic copy of the joint model.
            %
            %   gj_sym = gj.makeSym
            %
            % Inputs:
            %
            % Outputs:
            %   gj_sym: Converts of the original object into a symbolic model
            %   with all properties being symbolic variables.
            %
            % Notes::
            %
            %
            % Examples::
            %
            %
            % Author::
            %  Joern Malzahn
            %  Wesley Roozing
            %
            % See also getStateSpaceD, getTFd, genericJoint, jointBuilder.
            
            % Get all properties
            props = properties(obj);
            
            % Blacklist (non-variable property names)
            blacklist = {   'verbose';
                            'debug';
                            'name';
                            'paramName';
                            'modelName';
                            'nonlinearModelName';
                        };
            
            % Get symbolic properties
            symProps    = setdiff(props, blacklist);
            nProps      = numel(symProps);
            
            % Set each symbolic property to symbolic
            for iProps = 1:nProps
                obj.(symProps{iProps}) = sym(symProps{iProps},'real');
            end
        end
        
        

        
    end
    
    %__________________________________________________________________
    % Abstract methods - to be implemented by subclasses.
    methods(Abstract)
        %__________________________________________________________________
        % GETDYNAMICSMATRICES Get Dynamics Matrices for the Dynamics
        %
        %   [A, B, C, I, D, K] = gj.getDynamicsMatrices
        %
        % Inputs:
        %
        % Outputs:
        %   A: continuous time system matrix
        %   B: continuous time input matrix
        %   C: continuous time output matrix
        %   I: inertia matrix
        %   D: damping matrix
        %   K: stiffness matrix
        %
        % Notes::
        %   This is an abstract method. It has to be implemented by
        %   subclasses.
        %
        % Examples::
        %
        %
        % Author::
        %  Joern Malzahn
        %  Wesley Roozing
        %
        % See also getNonlinearDynamics, getStateSpace, getTFd, genericJoint.
        [A, B, C, I, D, K] = getDynamicsMatrices(obj)
        
        %__________________________________________________________________
        % GETDYNAMICSMATRICES Compute nonlinear dynamics
        %
        %   tau = gj.getNonlinearDynamics(x,dx)
        %
        % Inputs:
        %   x: position variable
        %  dx: temporal derivative of the position variable
        %
        % Outputs:
        %   tau: Generalized torque due to the nonlinear dynamics.
        %
        % Notes::
        %   This is an abstract method. It has to be implemented by
        %   subclasses.
        %
        % Examples::
        %
        %
        % Author::
        %  Joern Malzahn
        %  Wesley Roozing
        %
        % See also getDynamicsMatrices, getStateSpace, getTFd, genericJoint.
        tau = getNonlinearDynamics(obj, x, dx)
        
    end
    
end
