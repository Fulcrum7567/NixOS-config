{ inputs, ... }:
{
	imports = [
		"${inputs.nixos-hardware}/common/gpu/nvidia/prime.nix"
		"${inputs.nixos-hardware}/common/gpu/nvidia/ampere/default.nix"
		"${inputs.nixos-hardware}/common/gpu/nvidia/default.nix"

		"${inputs.nixos-hardware}/common/cpu/intel/default.nix"
		"${inputs.nixos-hardware}/common/cpu/intel/alder-lake/default.nix"

		"${inputs.nixos-hardware}/common/pc/default.nix"
		"${inputs.nixos-hardware}/common/pc/laptop/default.nix"
		"${inputs.nixos-hardware}/common/pc/ssd/default.nix/"



		"${inputs.nixos-hardware}/asus/battery.nix"
	];

	#hardware.nvidia.open = true;
	hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";
	hardware.nvidia.prime.intelBusId = "PCI:0:1:0";
	#hardware.nvidia.modesetting.enable = true;
}
