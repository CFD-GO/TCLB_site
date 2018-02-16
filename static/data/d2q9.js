var tclb_xml_scheme = {
  "Geometry": {
    "children": ["Wall", "Solid", "WVelocity", "WPressure", "WPressureL", "EPressure", "EVelocity", "NVelocity", "SVelocity", "NSymmetry", "SSymmetry", "BGK", "MRT", "DesignSpace", "Inlet", "Outlet", "DefaultZone", "None"],
    "attrs": []
  },
  "Solve": {
    "children": ["Params"],
    "attrs": {
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Main solution element. It runs a prescribed number of iterations.\n"]
  },
  "VTK": {
    "children": [],
    "attrs": {
      "what": {
        "value": [
          ["Rho"],
          ["U"],
          ["BOUNDARY"],
          ["COLLISION"],
          ["DESIGNSPACE"],
          ["OBJECTIVE"],
          ["SETTINGZONE"],
          ["NONE"],
          ["ALL"]
        ],
        "comment": ["List of Quantities and Geometry Components to export."],
        "type": ["list"]
      },
      "name": {
        "value": null,
        "comment": ["Name of the VTK file."],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Export VTK data"]
  },
  "TXT": {
    "children": [],
    "attrs": {
      "name": {
        "value": null,
        "comment": ["Name of the TXT file."],
        "type": null
      },
      "gzip": {
        "value": [true, false],
        "comment": ["If to compress the TXT output"],
        "type": ["select"]
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Export data to TXT file"]
  },
  "Catalyst": {
    "children": [],
    "attrs": {
      "export": {
        "value": ["CellData", "PointData"],
        "comment": ["Select if to provide the Catalyst co-processor with VTK Cell of Point Data"],
        "type": ["select"]
      },
      "script": {
        "value": null,
        "comment": ["Catalyst co-processing Python script"],
        "type": null
      },
      "preprocess": {
        "value": [true, false],
        "comment": ["If active, the Python script will be modified so that the files will be placed in the output directory"],
        "type": ["select"]
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Run Catalyst co-processor"]
  },
  "CLBConfig": {
    "children": ["Geometry", "Solve", "Adjoint", "Optimize", "Threshold", "ThresholdNow", "Repeat", "LoadBinary", "SaveBinary", "LoadMemoryDump", "SaveMemoryDump", "VTK", "TXT", "Catalyst", "Log", "Stop", "PID", "Sample", "CLBConfig", "Model", "Params", "Control", "SyntheticTurbulence"],
    "attrs": {
      "output": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Log": {
    "children": [],
    "attrs": {
      "name": {
        "value": null,
        "comment": {},
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Stop": {
    "children": [],
    "attrs": {
      "Times": {
        "value": null,
        "comment": ["Numer of times the change have to be below the limit to stop the computation."],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Allows to stop the computatation if a change of some Global is small for a longer time"]
  },
  "PID": {
    "children": [],
    "attrs": {
      "control": {
        "value": null,
        "comment": ["The setting to control (currently only zonal settings are supported)"],
        "type": null
      },
      "scale": {
        "value": null,
        "comment": ["The proportional rate D in PID controller"],
        "type": null
      },
      "DerivativeTime": {
        "value": null,
        "comment": ["The derivative time scale. D = P * DerivativeTime"],
        "type": null
      },
      "IntegrationTime": {
        "value": null,
        "comment": ["The integral time scale. I = P / IntegrationTime"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["PID controller. Allows to achive a specified value of an Global, with tweaking of a Setting"]
  },
  "Sample": {
    "children": [],
    "attrs": {
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      },
      "what": {
        "value": [
          ["Rho"],
          ["U"]
        ],
        "comment": ["List of Quantities to be sampled. By default all are sampled."],
        "type": ["list"]
      }
    },
    "comment": ["Effecient sampling of quantities on each iteration, without need for VTK"]
  },
  "Box": {
    "children": [],
    "attrs": []
  },
  "Pipe": {
    "children": [],
    "attrs": []
  },
  "Wedge": {
    "children": [],
    "attrs": {
      "direction": {
        "value": ["UpperLeft", "UpperRight", "BottomLeft", "BottomRight"],
        "comment": {},
        "type": ["select"]
      }
    }
  },
  "STL": {
    "children": [],
    "attrs": {
      "file": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Params": {
    "children": [],
    "attrs": {
      "gauge": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Model": {
    "children": ["Params", "Control", "SyntheticTurbulence"],
    "attrs": {
      "output": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Adjoint": {
    "children": ["Solve", "Adjoint", "Optimize", "Threshold", "ThresholdNow", "Repeat", "LoadBinary", "SaveBinary", "LoadMemoryDump", "SaveMemoryDump", "Params"],
    "attrs": {
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Optimize": {
    "children": ["Solve", "Adjoint", "Optimize", "Threshold", "ThresholdNow", "Repeat", "LoadBinary", "SaveBinary", "LoadMemoryDump", "SaveMemoryDump", "Params"],
    "attrs": {
      "Method": {
        "value": ["MMA", "L-BFGS-B", "COBYLA", "NELDERMEAD"],
        "comment": ["Optimization method"],
        "type": ["select"]
      },
      "Material": {
        "value": ["more", "less"],
        "comment": ["Optional constraint on \"amount of material\", which is the sum of Topological parameters"],
        "type": ["select"]
      },
      "XAbsTolerance": {
        "value": null,
        "comment": {},
        "type": null
      },
      "RelTolerance": {
        "value": null,
        "comment": ["Relative Tolerance"],
        "type": null
      },
      "AbsTolerance": {
        "value": null,
        "comment": ["Absolute Tolerance"],
        "type": null
      },
      "StopAtValue": {
        "value": null,
        "comment": ["At what value of the objective to stop"],
        "type": null
      },
      "MaxEvaluations": {
        "value": null,
        "comment": ["Maximal number of evalulations (optimizer iterations)"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "OptimalControl": {
    "children": [],
    "attrs": {
      "what": {
        "value": null,
        "comment": ["Select a time-dependent setting to optimize"],
        "type": null
      }
    }
  },
  "OptimalControlSecond": {
    "children": [],
    "attrs": {
      "what": {
        "value": null,
        "comment": ["Select a time-dependent setting to optimize"],
        "type": null
      },
      "lower": {
        "value": null,
        "comment": ["Lower limit on the value of the Setting"],
        "type": null
      },
      "upper": {
        "value": null,
        "comment": ["Upper limit on the value of the Setting"],
        "type": null
      }
    },
    "comment": ["Parametrises a time-dependend Setting with the value of every second iteration. Values inbetween are interpolated.\n"]
  },
  "Fourier": {
    "children": [],
    "attrs": {
      "modes": {
        "value": {
          "numeric": ["int"]
        },
        "comment": ["Number of Fourier modes to use for the parametrization"],
        "type": ["select"]
      },
      "lower": {
        "value": null,
        "comment": ["Lower limit on the Fourier coefficients"],
        "type": null
      },
      "upper": {
        "value": null,
        "comment": ["Upper limit on the Fourier coefficients"],
        "type": null
      }
    },
    "comment": ["Makes a truncated Fourier transform of a time-dependent Setting (OptimalControl)\n"]
  },
  "BSpline": {
    "children": [],
    "attrs": {
      "nodes": {
        "value": null,
        "comment": ["Number of degrees of freedom (parameters) of the b-spline"],
        "type": null
      },
      "periodic": {
        "value": [true, false],
        "comment": ["If the b-spline should be periotic in the control period"],
        "type": ["select"]
      },
      "lower": {
        "value": null,
        "comment": ["Lower limit on the values"],
        "type": null
      },
      "upper": {
        "value": null,
        "comment": ["Upper limit on the values"],
        "type": null
      }
    },
    "comment": ["Makes B-Spline transform/smoothing of a time-dependent Setting (OptimalControl)\n"]
  },
  "RepeatControl": {
    "children": [],
    "attrs": {
      "length": {
        "value": null,
        "comment": ["Length of the control to repeat"],
        "type": null
      },
      "lower": {
        "value": null,
        "comment": ["Lower limit on the values"],
        "type": null
      },
      "upper": {
        "value": null,
        "comment": ["Upper limit on the values"],
        "type": null
      }
    },
    "comment": ["Repeats a control for optimal control\n"]
  },
  "Threshold": {
    "children": ["Params"],
    "attrs": {
      "Levels": {
        "value": null,
        "comment": ["Number of Levels to calculate between 0 and 1"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Goes with a threshold from 0 to 1. Then for a specific threshold sets all the parameter below the threshold to 0 and above the threshold to 1. Then runs the calculation for the binary (0-1) parameter set.\n"]
  },
  "ThresholdNow": {
    "children": ["Params"],
    "attrs": {
      "Level": {
        "value": null,
        "comment": ["Threshold level to apply"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["For a specific threshold sets all the parameter below the threshold to 0 and above the threshold to 1. Then runs the calculation for the binary (0-1) parameter set.\n"]
  },
  "Repeat": {
    "children": ["Params"],
    "attrs": {
      "Times": {
        "value": null,
        "comment": ["Numer of Times to repeat a segment"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["A loop element"]
  },
  "Control": {
    "children": [],
    "attrs": {
      "Iterations": {
        "value": null,
        "comment": ["Length of the time-dependentcy"],
        "type": null
      }
    },
    "comment": ["Element prescribing time-dependent Settings"]
  },
  "SyntheticTurbulence": {
    "children": [],
    "attrs": {
      "Modes": {
        "value": null,
        "comment": ["Number of harmonic modes to generate for the turbulence"],
        "type": null
      },
      "Spread": {
        "value": ["Even", "Log", "Quantile"],
        "comment": ["The way to divide the spectrum to a finite number of modes"],
        "type": ["select"]
      },
      "Spectrum": {
        "value": ["Von Karman", "One Wave"],
        "comment": ["Type of spectrum to use"],
        "type": ["select"]
      },
      "MainWaveLength": {
        "value": null,
        "comment": ["Main wave-length in the Von Karman spectrum"],
        "type": null
      },
      "DiffusionWaveLength": {
        "value": null,
        "comment": ["Diffusion scale wave-length in the Von Karman spectrum"],
        "type": null
      },
      "MinWaveLength": {
        "value": null,
        "comment": ["Minimal space wave-length"],
        "type": null
      },
      "MaxWaveLength": {
        "value": null,
        "comment": ["Maximal space wave-length"],
        "type": null
      },
      "TimeWaveLength": {
        "value": null,
        "comment": ["Time wave-length of the syntetic turbulence (can be also `TimeWaveNumber` or `TimeWaveFrequency`)"],
        "type": null
      }
    },
    "comment": ["Prescribe properties of the synthetic turbulence generated for initialization and boundary conditions"]
  },
  "LoadBinary": {
    "children": ["Params"],
    "attrs": {
      "file": {
        "value": null,
        "comment": ["path to a binary file (without the suffix)"],
        "type": null
      },
      "comp": {
        "value": null,
        "comment": ["Field to load from the binary file"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Load a Field from a binary file (low level)"]
  },
  "SaveBinary": {
    "children": ["Params"],
    "attrs": {
      "file": {
        "value": null,
        "comment": ["the name of the binary file"],
        "type": null
      },
      "filename": {
        "value": null,
        "comment": ["full path to the binary file"],
        "type": null
      },
      "comp": {
        "value": null,
        "comment": ["Field to save to the binary file"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Save a Field to a binary file (low level)"]
  },
  "LoadMemoryDump": {
    "children": ["Params"],
    "attrs": {
      "file": {
        "value": null,
        "comment": ["path to a binary file (without the suffix)"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Load all fields from a dump created by Save element"]
  },
  "SaveMemoryDump": {
    "children": ["Params"],
    "attrs": {
      "file": {
        "value": null,
        "comment": ["the name of the binary file"],
        "type": null
      },
      "filename": {
        "value": null,
        "comment": ["full path to the binary file"],
        "type": null
      },
      "Iterations": {
        "value": null,
        "comment": {},
        "type": null
      }
    },
    "comment": ["Save all fields, to be loaded later on with LoadMemoryDump\nWarning: Save and Load Memory Dump have to be used on the *same number of cores*, same model and same precision.\n"]
  },
  "Wall": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Solid": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "WVelocity": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "WPressure": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "WPressureL": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "EPressure": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "EVelocity": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "NVelocity": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "SVelocity": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "NSymmetry": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "SSymmetry": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "BGK": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "MRT": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "DesignSpace": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Inlet": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "Outlet": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "DefaultZone": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "None": {
    "children": ["Box", "Pipe", "Wedge", "STL"],
    "attrs": {
      "mask": {
        "value": null,
        "comment": {},
        "type": null
      }
    }
  },
  "!top": ["CLBConfig"],
  "!attrs": []
};

