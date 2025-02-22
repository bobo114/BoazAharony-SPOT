classdef PWM_Write < matlab.System & coder.ExternalDependency
    %
    % System object template for a GPIO_Write block.
    % 
    % This template includes most, but not all, possible properties,
    % attributes, and methods that you can implement for a System object in
    % Simulink.
    %
    
    % Copyright 2021 The MathWorks, Inc.
    %#codegen
    %#ok<*EMCA>
    
    properties
        % Specify custom variable names

    end 
    
    properties (Nontunable)
        % Public, non-tunable properties.
    end
    
    methods
        % Constructor
        function obj = PWM_Write(varargin)
            % Support name-value pair arguments when constructing the object.
            setProperties(obj,nargin,varargin{:});
        end
    end

    methods (Access=protected)
        function setupImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Simulation setup code
            else
                coder.cinclude('pca9685_controller.h');
                coder.ceval('initPCA9685');
            end
        end
        
        function stepImpl(obj, u1,u2,u3,u4,u5,u6,u7,u8)
            if isempty(coder.target)
                % Simulation output code
            else
                coder.cinclude('pca9685_controller.h');
                coder.ceval('commandPWM', u1, u2, u3, u4, u5, u6, u7, u8);
            end
        end
        
        function releaseImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Simulation termination code
            else
                % Termination code for PCA9685
                coder.cinclude('pca9685_controller.h');
                coder.ceval('commandPWM', 0, 0, 0, 0, 0, 0, 0, 0);
                coder.ceval('closePCA9685');
            end
        end
    end
    
    methods (Access=protected)
        %% Define input properties
        function num = getNumInputsImpl(~)
            num = 8;
        end
        
        function num = getNumOutputsImpl(~)
            num = 0;
        end
        
        function flag = isInputSizeMutableImpl(~,~)
            flag = false;
        end
        
        function flag = isInputComplexityMutableImpl(~,~)
            flag = false;
        end
        
        function validateInputsImpl(~, u)
            if isempty(coder.target)
                % Run input validation only in Simulation
                validateattributes(u,{'double'},{'scalar'},'','u');
            end
        end
        
        function icon = getIconImpl(~)
            % Define a string as the icon for the System block in Simulink.
            icon = 'PWM_Write';
        end
    end
    
    methods (Static, Access=protected)
        function simMode = getSimulateUsingImpl(~)
            simMode = 'Interpreted execution';
        end
        
        function isVisible = showSimulateUsingImpl
            isVisible = false;
        end
        
        function header = getHeaderImpl
            header = matlab.system.display.Header('GPIO_Write','Title',...
                'Debugging Block','Text',...
                ['This block allows you to control the PWM pins on the PCA9685 board via I2C.' ...
                ' The inputs are the duty cycle commands for thrusters 1-8 in order (input #1 is thruster #1).']);
        end
        
    end
    
    methods (Static)
        function name = getDescriptiveName()
            name = 'PWM_Write';
        end
        
        function b = isSupportedContext(context)
            b = context.isCodeGenTarget('rtw');
        end
        
        function updateBuildInfo(buildInfo, context)
            if context.isCodeGenTarget('rtw')
                srcDir = fullfile(fileparts(mfilename('fullpath')),'src');
                includeDir = fullfile(fileparts(mfilename('fullpath')),'include');
                addIncludePaths(buildInfo,includeDir);
                % Add the source and header files to the build
                addIncludeFiles(buildInfo,'pca9685_controller.h',includeDir);
                addSourceFiles(buildInfo,'pca9685_controller.cpp',srcDir); % Assuming .cpp extension
            end
        end
    end
end
