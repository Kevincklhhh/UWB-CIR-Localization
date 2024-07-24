MEMORY
{
  UNPLACED_SECTIONS (wx) : ORIGIN = 0x100000000, LENGTH = 0
  RAM1 (wx) : ORIGIN = 0x20000000, LENGTH = 0x00020000
  FLASH (wx) : ORIGIN = 0x00000000, LENGTH = 0x00080000
}

SECTIONS
{
  __RAM1_segment_start__ = 0x20000000;
  __RAM1_segment_end__ = 0x20020000;
  __RAM1_segment_size__ = 0x00020000;
  __FLASH_segment_start__ = 0x00000000;
  __FLASH_segment_end__ = 0x00080000;
  __FLASH_segment_size__ = 0x00080000;

  __HEAPSIZE__ = 0;
  __SEGGER_RTL_vfprintf = __SEGGER_RTL_vfprintf_short_float_long;
  __SEGGER_RTL_vfscanf = __SEGGER_RTL_vfscanf_long;
  __STACKSIZE_PROCESS__ = 0;
  __STACKSIZE__ = 2048;

  __vectors_ram_load_start__ = 0x20000000;
  .vectors_ram 0x20000000 (NOLOAD) : AT(0x20000000)
  {
    __vectors_ram_start__ = .;
    __app_ram_start__ =   __vectors_ram_start__;
    *(.vectors_ram .vectors_ram.*)
  }
  __vectors_ram_end__ = __vectors_ram_start__ + SIZEOF(.vectors_ram);
  __vectors_ram_size__ = SIZEOF(.vectors_ram);
  __vectors_ram_load_end__ = __vectors_ram_end__;

  . = ASSERT(__vectors_ram_start__ == __vectors_ram_end__ || (__vectors_ram_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .vectors_ram is too large to fit in RAM1 memory segment");

  __nrf_sections_run_load_start__ = ALIGN(__vectors_ram_end__ , 4);
  .nrf_sections_run ALIGN(__vectors_ram_end__ , 4) (NOLOAD) : AT(ALIGN(__vectors_ram_end__ , 4))
  {
    __nrf_sections_run_start__ = .;
    __start_nrf_sections_run =   __nrf_sections_run_start__;
    KEEP(*(.nrf_sections_run .nrf_sections_run.*))
  }
  __nrf_sections_run_end__ = __nrf_sections_run_start__ + SIZEOF(.nrf_sections_run);
  __nrf_sections_run_size__ = SIZEOF(.nrf_sections_run);
  __nrf_sections_run_load_end__ = __nrf_sections_run_end__;

  . = ASSERT(__nrf_sections_run_start__ == __nrf_sections_run_end__ || (__nrf_sections_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .nrf_sections_run is too large to fit in RAM1 memory segment");

  __vectors_load_start__ = 0;
  .vectors 0 : AT(0)
  {
    __vectors_start__ = .;
    *(.vectors .vectors.*)
  }
  __vectors_end__ = __vectors_start__ + SIZEOF(.vectors);
  __vectors_size__ = SIZEOF(.vectors);
  __vectors_load_end__ = __vectors_end__;

  . = ASSERT(__vectors_start__ == __vectors_end__ || (__vectors_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .vectors is too large to fit in FLASH memory segment");

  __fconfig_load_start__ = 0x1e000;
  .fconfig 0x1e000 : AT(0x1e000)
  {
    __fconfig_start__ = .;
    __fconfig_start =   __fconfig_start__;
    KEEP(*(.fconfig .fconfig.*))
    . = ALIGN(MAX(__fconfig_start__ + 0x1000 , .), 4096);
  }
  __fconfig_end__ = __fconfig_start__ + SIZEOF(.fconfig);
  __fconfig_size__ = SIZEOF(.fconfig);
  __fconfig_load_end__ = __fconfig_end__;

  . = ASSERT(__fconfig_start__ == __fconfig_end__ || (__fconfig_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .fconfig is too large to fit in FLASH memory segment");
  . = ASSERT(__vectors_end__ <= __fconfig_start__ , "error: section .vectors overlaps absolute placed section .fconfig");

  . = ASSERT(0x1000  == ALIGN(0x1000, 4096), "error: .fconfig section size does not match alignment");

  . = ASSERT(__fconfig_size__ <= 0x1000 , "error: .fconfig section is larger than specified size");

  __init_load_start__ = 0x1f000;
  .init 0x1f000 : AT(0x1f000)
  {
    __init_start__ = .;
    *(.init .init.*)
  }
  __init_end__ = __init_start__ + SIZEOF(.init);
  __init_size__ = SIZEOF(.init);
  __init_load_end__ = __init_end__;

  . = ASSERT(__init_start__ == __init_end__ || (__init_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .init is too large to fit in FLASH memory segment");
  . = ASSERT(__fconfig_end__ <= __init_start__ , "error: section .fconfig overlaps absolute placed section .init");

  __init_rodata_load_start__ = ALIGN(__init_end__ , 4);
  .init_rodata ALIGN(__init_end__ , 4) : AT(ALIGN(__init_end__ , 4))
  {
    __init_rodata_start__ = .;
    *(.init_rodata .init_rodata.*)
  }
  __init_rodata_end__ = __init_rodata_start__ + SIZEOF(.init_rodata);
  __init_rodata_size__ = SIZEOF(.init_rodata);
  __init_rodata_load_end__ = __init_rodata_end__;

  . = ASSERT(__init_rodata_start__ == __init_rodata_end__ || (__init_rodata_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .init_rodata is too large to fit in FLASH memory segment");

  __text_load_start__ = ALIGN(__init_rodata_end__ , 4);
  .text ALIGN(__init_rodata_end__ , 4) : AT(ALIGN(__init_rodata_end__ , 4))
  {
    __text_start__ = .;
    *(.text .text.* .gnu.linkonce.t.* .glue_7t .glue_7 .gcc_except_table .ARM.extab* .gnu.linkonce.armextab.*)
  }
  __text_end__ = __text_start__ + SIZEOF(.text);
  __text_size__ = SIZEOF(.text);
  __text_load_end__ = __text_end__;

  . = ASSERT(__text_start__ == __text_end__ || (__text_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .text is too large to fit in FLASH memory segment");

  __log_const_data_load_start__ = ALIGN(__text_end__ , 4);
  .log_const_data ALIGN(__text_end__ , 4) : AT(ALIGN(__text_end__ , 4))
  {
    __log_const_data_start__ = .;
    __start_log_const_data =   __log_const_data_start__;
    KEEP(*(SORT(.log_const_data*)))
  }
  __log_const_data_end__ = __log_const_data_start__ + SIZEOF(.log_const_data);
  __log_const_data_size__ = SIZEOF(.log_const_data);
  __stop_log_const_data =   __log_const_data_end__;
  __log_const_data_load_end__ = __log_const_data_end__;

  . = ASSERT(__log_const_data_start__ == __log_const_data_end__ || (__log_const_data_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .log_const_data is too large to fit in FLASH memory segment");

  __nrf_sections_load_start__ = ALIGN(__log_const_data_end__ , 4);
  .nrf_sections ALIGN(__log_const_data_end__ , 4) (NOLOAD) : AT(ALIGN(__log_const_data_end__ , 4))
  {
    __nrf_sections_start__ = .;
    __start_nrf_sections =   __nrf_sections_start__;
    KEEP(*(.nrf_sections .nrf_sections.*))
  }
  __nrf_sections_end__ = __nrf_sections_start__ + SIZEOF(.nrf_sections);
  __nrf_sections_size__ = SIZEOF(.nrf_sections);
  __nrf_sections_load_end__ = __nrf_sections_end__;

  . = ASSERT(__nrf_sections_start__ == __nrf_sections_end__ || (__nrf_sections_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .nrf_sections is too large to fit in FLASH memory segment");

  __log_dynamic_data_load_start__ = ALIGN(__nrf_sections_end__ , 4);
  .log_dynamic_data ALIGN(__nrf_sections_run_end__ , 4) : AT(ALIGN(__nrf_sections_end__ , 4))
  {
    __log_dynamic_data_start__ = .;
    KEEP(*(SORT(.log_dynamic_data*)))
  }
  __log_dynamic_data_end__ = __log_dynamic_data_start__ + SIZEOF(.log_dynamic_data);
  __log_dynamic_data_size__ = SIZEOF(.log_dynamic_data);
  __log_dynamic_data_load_end__ = __log_dynamic_data_load_start__ + SIZEOF(.log_dynamic_data);

  . = ASSERT(__log_dynamic_data_load_start__ == __log_dynamic_data_load_end__ || (__log_dynamic_data_load_end__ - __FLASH_segment_start__) <=  __FLASH_segment_size__ , "error: .log_dynamic_data is too large to fit in FLASH memory segment");

  .log_dynamic_data_run ALIGN(__nrf_sections_run_end__ , 4) (NOLOAD) :
  {
    __log_dynamic_data_run_start__ = .;
    __start_log_dynamic_data =   __log_dynamic_data_run_start__;
  }
  __log_dynamic_data_run_end__ = __log_dynamic_data_run_start__ + SIZEOF(.log_dynamic_data);
  __log_dynamic_data_run_size__ = __log_dynamic_data_run_end__ - __log_dynamic_data_run_start__;
  __stop_log_dynamic_data =   __log_dynamic_data_run_end__;
  __log_dynamic_data_run_load_end__ = __log_dynamic_data_run_end__;

  . = ASSERT(__log_dynamic_data_run_start__ == __log_dynamic_data_run_end__ || (__log_dynamic_data_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .log_dynamic_data_run is too large to fit in RAM1 memory segment");

  __nrf_sections_run_end_load_start__ = ALIGN(__log_dynamic_data_run_end__ , 4);
  .nrf_sections_run_end ALIGN(__log_dynamic_data_run_end__ , 4) (NOLOAD) : AT(ALIGN(__log_dynamic_data_run_end__ , 4))
  {
    __nrf_sections_run_end_start__ = .;
    __end_nrf_sections_run =   __nrf_sections_run_end_start__;
    KEEP(*(.nrf_sections_run_end .nrf_sections_run_end.*))
  }
  __nrf_sections_run_end_end__ = __nrf_sections_run_end_start__ + SIZEOF(.nrf_sections_run_end);
  __nrf_sections_run_end_size__ = SIZEOF(.nrf_sections_run_end);
  __nrf_sections_run_end_load_end__ = __nrf_sections_run_end_end__;

  . = ASSERT(__nrf_sections_run_end_start__ == __nrf_sections_run_end_end__ || (__nrf_sections_run_end_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .nrf_sections_run_end is too large to fit in RAM1 memory segment");

  __rconfig_load_start__ = ALIGN(__nrf_sections_run_end_end__ , 4);
  .rconfig ALIGN(__nrf_sections_run_end_end__ , 4) (NOLOAD) : AT(ALIGN(__nrf_sections_run_end_end__ , 4))
  {
    __rconfig_start__ = .;
    __rconfig_start =   __rconfig_start__;
    KEEP(*(.rconfig .rconfig.*))
  }
  __rconfig_end__ = __rconfig_start__ + SIZEOF(.rconfig);
  __rconfig_size__ = SIZEOF(.rconfig);
  __rconfig_end =   __rconfig_end__;
  __rconfig_load_end__ = __rconfig_end__;

  . = ASSERT(__rconfig_start__ == __rconfig_end__ || (__rconfig_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .rconfig is too large to fit in RAM1 memory segment");

  __rconfig_crc_load_start__ = ALIGN(__rconfig_end__ , 4);
  .rconfig_crc ALIGN(__rconfig_end__ , 4) (NOLOAD) : AT(ALIGN(__rconfig_end__ , 4))
  {
    __rconfig_crc_start__ = .;
    __rconfig_end =   __rconfig_crc_start__;
    KEEP(*(.rconfig_crc .rconfig_crc.*))
  }
  __rconfig_crc_end__ = __rconfig_crc_start__ + SIZEOF(.rconfig_crc);
  __rconfig_crc_size__ = SIZEOF(.rconfig_crc);
  __rconfig_crc_end =   __rconfig_crc_end__;
  __rconfig_crc_load_end__ = __rconfig_crc_end__;

  . = ASSERT(__rconfig_crc_start__ == __rconfig_crc_end__ || (__rconfig_crc_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .rconfig_crc is too large to fit in RAM1 memory segment");

  __dw_drivers_load_start__ = ALIGN(__log_dynamic_data_load_start__ + SIZEOF(.log_dynamic_data) , 4);
  .dw_drivers ALIGN(__log_dynamic_data_load_start__ + SIZEOF(.log_dynamic_data) , 4) : AT(ALIGN(__log_dynamic_data_load_start__ + SIZEOF(.log_dynamic_data) , 4))
  {
    __dw_drivers_start__ = .;
    __dw_drivers_start =   __dw_drivers_start__;
    KEEP(*(.dw_drivers .dw_drivers.*))
  }
  __dw_drivers_end__ = __dw_drivers_start__ + SIZEOF(.dw_drivers);
  __dw_drivers_size__ = SIZEOF(.dw_drivers);
  __dw_drivers_end =   __dw_drivers_end__;
  __dw_drivers_load_end__ = __dw_drivers_end__;

  . = ASSERT(__dw_drivers_start__ == __dw_drivers_end__ || (__dw_drivers_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .dw_drivers is too large to fit in FLASH memory segment");

  __known_commands_anytime_load_start__ = ALIGN(__dw_drivers_end__ , 4);
  .known_commands_anytime ALIGN(__dw_drivers_end__ , 4) : AT(ALIGN(__dw_drivers_end__ , 4))
  {
    __known_commands_anytime_start__ = .;
    __known_commands_start =   __known_commands_anytime_start__;
    KEEP(*(.known_commands_anytime .known_commands_anytime.*))
  }
  __known_commands_anytime_end__ = __known_commands_anytime_start__ + SIZEOF(.known_commands_anytime);
  __known_commands_anytime_size__ = SIZEOF(.known_commands_anytime);
  __known_commands_anytime_load_end__ = __known_commands_anytime_end__;

  . = ASSERT(__known_commands_anytime_start__ == __known_commands_anytime_end__ || (__known_commands_anytime_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .known_commands_anytime is too large to fit in FLASH memory segment");

  __known_commands_app_load_start__ = ALIGN(__known_commands_anytime_end__ , 4);
  .known_commands_app ALIGN(__known_commands_anytime_end__ , 4) : AT(ALIGN(__known_commands_anytime_end__ , 4))
  {
    __known_commands_app_start__ = .;
    __known_commands_app_start =   __known_commands_app_start__;
    KEEP(*(.known_commands_app .known_commands_app.*))
  }
  __known_commands_app_end__ = __known_commands_app_start__ + SIZEOF(.known_commands_app);
  __known_commands_app_size__ = SIZEOF(.known_commands_app);
  __known_commands_app_load_end__ = __known_commands_app_end__;

  . = ASSERT(__known_commands_app_start__ == __known_commands_app_end__ || (__known_commands_app_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .known_commands_app is too large to fit in FLASH memory segment");

  __known_app_subcommands_load_start__ = ALIGN(__known_commands_app_end__ , 4);
  .known_app_subcommands ALIGN(__known_commands_app_end__ , 4) : AT(ALIGN(__known_commands_app_end__ , 4))
  {
    __known_app_subcommands_start__ = .;
    __known_app_subcommands_start =   __known_app_subcommands_start__;
    KEEP(*(.known_app_subcommands .known_app_subcommands.*))
  }
  __known_app_subcommands_end__ = __known_app_subcommands_start__ + SIZEOF(.known_app_subcommands);
  __known_app_subcommands_size__ = SIZEOF(.known_app_subcommands);
  __known_app_subcommands_load_end__ = __known_app_subcommands_end__;

  . = ASSERT(__known_app_subcommands_start__ == __known_app_subcommands_end__ || (__known_app_subcommands_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .known_app_subcommands is too large to fit in FLASH memory segment");

  __known_commands_ilde_load_start__ = ALIGN(__known_app_subcommands_end__ , 4);
  .known_commands_ilde ALIGN(__known_app_subcommands_end__ , 4) : AT(ALIGN(__known_app_subcommands_end__ , 4))
  {
    __known_commands_ilde_start__ = .;
    __known_commands_ilde_start =   __known_commands_ilde_start__;
    KEEP(*(.known_commands_ilde .known_commands_ilde.*))
  }
  __known_commands_ilde_end__ = __known_commands_ilde_start__ + SIZEOF(.known_commands_ilde);
  __known_commands_ilde_size__ = SIZEOF(.known_commands_ilde);
  __known_commands_ilde_load_end__ = __known_commands_ilde_end__;

  . = ASSERT(__known_commands_ilde_start__ == __known_commands_ilde_end__ || (__known_commands_ilde_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .known_commands_ilde is too large to fit in FLASH memory segment");

  __known_commands_service_load_start__ = ALIGN(__known_commands_ilde_end__ , 4);
  .known_commands_service ALIGN(__known_commands_ilde_end__ , 4) : AT(ALIGN(__known_commands_ilde_end__ , 4))
  {
    __known_commands_service_start__ = .;
    __known_commands_service_start =   __known_commands_service_start__;
    KEEP(*(.known_commands_service .known_commands_service.*))
  }
  __known_commands_service_end__ = __known_commands_service_start__ + SIZEOF(.known_commands_service);
  __known_commands_service_size__ = SIZEOF(.known_commands_service);
  __known_commands_end =   __known_commands_service_end__;
  __known_commands_service_load_end__ = __known_commands_service_end__;

  . = ASSERT(__known_commands_service_start__ == __known_commands_service_end__ || (__known_commands_service_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .known_commands_service is too large to fit in FLASH memory segment");

  __known_apps_load_start__ = ALIGN(__known_commands_service_end__ , 4);
  .known_apps ALIGN(__known_commands_service_end__ , 4) : AT(ALIGN(__known_commands_service_end__ , 4))
  {
    __known_apps_start__ = .;
    __known_apps_start =   __known_apps_start__;
    KEEP(*(.known_apps .known_apps.*))
  }
  __known_apps_end__ = __known_apps_start__ + SIZEOF(.known_apps);
  __known_apps_size__ = SIZEOF(.known_apps);
  __known_apps_end =   __known_apps_end__;
  __known_apps_load_end__ = __known_apps_end__;

  . = ASSERT(__known_apps_start__ == __known_apps_end__ || (__known_apps_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .known_apps is too large to fit in FLASH memory segment");

  __config_entry_load_start__ = ALIGN(__known_apps_end__ , 4);
  .config_entry ALIGN(__known_apps_end__ , 4) : AT(ALIGN(__known_apps_end__ , 4))
  {
    __config_entry_start__ = .;
    __config_entry_start =   __config_entry_start__;
    KEEP(*(.config_entry .config_entry.*))
  }
  __config_entry_end__ = __config_entry_start__ + SIZEOF(.config_entry);
  __config_entry_size__ = SIZEOF(.config_entry);
  __config_entry_end =   __config_entry_end__;
  __config_entry_load_end__ = __config_entry_end__;

  . = ASSERT(__config_entry_start__ == __config_entry_end__ || (__config_entry_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .config_entry is too large to fit in FLASH memory segment");

  __dtors_load_start__ = ALIGN(__config_entry_end__ , 4);
  .dtors ALIGN(__config_entry_end__ , 4) : AT(ALIGN(__config_entry_end__ , 4))
  {
    __dtors_start__ = .;
    KEEP (*(SORT(.dtors.*))) KEEP (*(.dtors)) KEEP (*(.fini_array)) KEEP (*(SORT(.fini_array.*)))
  }
  __dtors_end__ = __dtors_start__ + SIZEOF(.dtors);
  __dtors_size__ = SIZEOF(.dtors);
  __dtors_load_end__ = __dtors_end__;

  . = ASSERT(__dtors_start__ == __dtors_end__ || (__dtors_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .dtors is too large to fit in FLASH memory segment");

  __ctors_load_start__ = ALIGN(__dtors_end__ , 4);
  .ctors ALIGN(__dtors_end__ , 4) : AT(ALIGN(__dtors_end__ , 4))
  {
    __ctors_start__ = .;
    KEEP (*(SORT(.ctors.*))) KEEP (*(.ctors)) KEEP (*(.init_array)) KEEP (*(SORT(.init_array.*)))
  }
  __ctors_end__ = __ctors_start__ + SIZEOF(.ctors);
  __ctors_size__ = SIZEOF(.ctors);
  __ctors_load_end__ = __ctors_end__;

  . = ASSERT(__ctors_start__ == __ctors_end__ || (__ctors_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .ctors is too large to fit in FLASH memory segment");

  __rodata_load_start__ = ALIGN(__ctors_end__ , 4);
  .rodata ALIGN(__ctors_end__ , 4) : AT(ALIGN(__ctors_end__ , 4))
  {
    __rodata_start__ = .;
    *(.rodata .rodata.* .gnu.linkonce.r.*)
  }
  __rodata_end__ = __rodata_start__ + SIZEOF(.rodata);
  __rodata_size__ = SIZEOF(.rodata);
  __rodata_load_end__ = __rodata_end__;

  . = ASSERT(__rodata_start__ == __rodata_end__ || (__rodata_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .rodata is too large to fit in FLASH memory segment");

  __ARM.exidx_load_start__ = ALIGN(__rodata_end__ , 4);
  .ARM.exidx ALIGN(__rodata_end__ , 4) : AT(ALIGN(__rodata_end__ , 4))
  {
    __ARM.exidx_start__ = .;
    __exidx_start =   __ARM.exidx_start__;
    *(.ARM.exidx .ARM.exidx.*)
  }
  __ARM.exidx_end__ = __ARM.exidx_start__ + SIZEOF(.ARM.exidx);
  __ARM.exidx_size__ = SIZEOF(.ARM.exidx);
  __exidx_end =   __ARM.exidx_end__;
  __ARM.exidx_load_end__ = __ARM.exidx_end__;

  . = ASSERT(__ARM.exidx_start__ == __ARM.exidx_end__ || (__ARM.exidx_end__ - __FLASH_segment_start__) <= __FLASH_segment_size__ , "error: .ARM.exidx is too large to fit in FLASH memory segment");

  __fast_load_start__ = ALIGN(__ARM.exidx_end__ , 4);
  .fast ALIGN(__rconfig_crc_end__ , 4) : AT(ALIGN(__ARM.exidx_end__ , 4))
  {
    __fast_start__ = .;
    *(.fast .fast.*)
  }
  __fast_end__ = __fast_start__ + SIZEOF(.fast);
  __fast_size__ = SIZEOF(.fast);
  __fast_load_end__ = __fast_load_start__ + SIZEOF(.fast);

  . = ASSERT(__fast_load_start__ == __fast_load_end__ || (__fast_load_end__ - __FLASH_segment_start__) <=  __FLASH_segment_size__ , "error: .fast is too large to fit in FLASH memory segment");

  .fast_run ALIGN(__rconfig_crc_end__ , 4) (NOLOAD) :
  {
    __fast_run_start__ = .;
  }
  __fast_run_end__ = __fast_run_start__ + SIZEOF(.fast);
  __fast_run_size__ = __fast_run_end__ - __fast_run_start__;
  __fast_run_load_end__ = __fast_run_end__;

  . = ASSERT(__fast_run_start__ == __fast_run_end__ || (__fast_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .fast_run is too large to fit in RAM1 memory segment");

  __data_load_start__ = ALIGN(__fast_load_start__ + SIZEOF(.fast) , 4);
  .data ALIGN(__fast_run_end__ , 4) : AT(ALIGN(__fast_load_start__ + SIZEOF(.fast) , 4))
  {
    __data_start__ = .;
    *(.data .data.* .gnu.linkonce.d.*)
  }
  __data_end__ = __data_start__ + SIZEOF(.data);
  __data_size__ = SIZEOF(.data);
  __data_load_end__ = __data_load_start__ + SIZEOF(.data);

  . = ASSERT(__data_load_start__ == __data_load_end__ || (__data_load_end__ - __FLASH_segment_start__) <=  __FLASH_segment_size__ , "error: .data is too large to fit in FLASH memory segment");

  .data_run ALIGN(__fast_run_end__ , 4) (NOLOAD) :
  {
    __data_run_start__ = .;
  }
  __data_run_end__ = __data_run_start__ + SIZEOF(.data);
  __data_run_size__ = __data_run_end__ - __data_run_start__;
  __data_run_load_end__ = __data_run_end__;

  . = ASSERT(__data_run_start__ == __data_run_end__ || (__data_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .data_run is too large to fit in RAM1 memory segment");

  __tdata_load_start__ = ALIGN(__data_load_start__ + SIZEOF(.data) , 4);
  .tdata ALIGN(__data_run_end__ , 4) : AT(ALIGN(__data_load_start__ + SIZEOF(.data) , 4))
  {
    __tdata_start__ = .;
    *(.tdata .tdata.*)
  }
  __tdata_end__ = __tdata_start__ + SIZEOF(.tdata);
  __tdata_size__ = SIZEOF(.tdata);
  __tdata_load_end__ = __tdata_load_start__ + SIZEOF(.tdata);

  __FLASH_segment_used_end__ = ALIGN(__data_load_start__ + SIZEOF(.data) , 4) + SIZEOF(.tdata);
  __FLASH_segment_used_size__ = __FLASH_segment_used_end__ - __FLASH_segment_start__;

  . = ASSERT(__tdata_load_start__ == __tdata_load_end__ || (__tdata_load_end__ - __FLASH_segment_start__) <=  __FLASH_segment_size__ , "error: .tdata is too large to fit in FLASH memory segment");

  .tdata_run ALIGN(__data_run_end__ , 4) (NOLOAD) :
  {
    __tdata_run_start__ = .;
  }
  __tdata_run_end__ = __tdata_run_start__ + SIZEOF(.tdata);
  __tdata_run_size__ = __tdata_run_end__ - __tdata_run_start__;
  __tdata_run_load_end__ = __tdata_run_end__;

  . = ASSERT(__tdata_run_start__ == __tdata_run_end__ || (__tdata_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .tdata_run is too large to fit in RAM1 memory segment");

  __bss_load_start__ = ALIGN(__tdata_run_end__ , 4);
  .bss ALIGN(__tdata_run_end__ , 4) (NOLOAD) : AT(ALIGN(__tdata_run_end__ , 4))
  {
    __bss_start__ = .;
    *(.bss .bss.* .gnu.linkonce.b.*) *(COMMON)
  }
  __bss_end__ = __bss_start__ + SIZEOF(.bss);
  __bss_size__ = SIZEOF(.bss);
  __bss_load_end__ = __bss_end__;

  . = ASSERT(__bss_start__ == __bss_end__ || (__bss_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .bss is too large to fit in RAM1 memory segment");

  __tbss_load_start__ = ALIGN(__bss_end__ , 4);
  .tbss ALIGN(__bss_end__ , 4) (NOLOAD) : AT(ALIGN(__bss_end__ , 4))
  {
    __tbss_start__ = .;
    *(.tbss .tbss.*)
  }
  __tbss_end__ = __tbss_start__ + SIZEOF(.tbss);
  __tbss_size__ = SIZEOF(.tbss);
  __tbss_load_end__ = __tbss_end__;

  . = ASSERT(__tbss_start__ == __tbss_end__ || (__tbss_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .tbss is too large to fit in RAM1 memory segment");

  __nrf_balloc_load_start__ = ALIGN(__tbss_end__ , 4);
  .nrf_balloc ALIGN(__tbss_end__ , 4) (NOLOAD) : AT(ALIGN(__tbss_end__ , 4))
  {
    __nrf_balloc_start__ = .;
    *(.nrf_balloc .nrf_balloc.*)
  }
  __nrf_balloc_end__ = __nrf_balloc_start__ + SIZEOF(.nrf_balloc);
  __nrf_balloc_size__ = SIZEOF(.nrf_balloc);
  __nrf_balloc_load_end__ = __nrf_balloc_end__;

  . = ASSERT(__nrf_balloc_start__ == __nrf_balloc_end__ || (__nrf_balloc_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .nrf_balloc is too large to fit in RAM1 memory segment");

  __heap_load_start__ = ALIGN(__nrf_balloc_end__ , 4);
  .heap ALIGN(__nrf_balloc_end__ , 4) (NOLOAD) : AT(ALIGN(__nrf_balloc_end__ , 4))
  {
    __heap_start__ = .;
    *(.heap .heap.*)
    . = ALIGN(MAX(__heap_start__ + __HEAPSIZE__ , .), 4);
  }
  __heap_end__ = __heap_start__ + SIZEOF(.heap);
  __heap_size__ = SIZEOF(.heap);
  __heap_load_end__ = __heap_end__;

  . = ASSERT(__heap_start__ == __heap_end__ || (__heap_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .heap is too large to fit in RAM1 memory segment");

  . = ASSERT(__HEAPSIZE__  == ALIGN(__HEAPSIZE__, 4), "error: .heap section size does not match alignment");

  . = ASSERT(__heap_size__ <= __HEAPSIZE__ , "error: .heap section is larger than specified size");

  __stack_load_start__ = __RAM1_segment_start__ + (__RAM1_segment_size__ - 2048);
  .stack __RAM1_segment_start__ + (__RAM1_segment_size__ - 2048) (NOLOAD) : AT(__RAM1_segment_start__ + (__RAM1_segment_size__ - 2048))
  {
    __stack_start__ = .;
    __StackLimit =   __stack_start__;
    *(.stack .stack.*)
    . = ALIGN(MAX(__stack_start__ + __STACKSIZE__ , .), 8);
  }
  __stack_end__ = __stack_start__ + SIZEOF(.stack);
  __stack_size__ = SIZEOF(.stack);
  __StackTop =   __stack_end__;
  __stack_load_end__ = __stack_end__;

  . = ASSERT(__stack_start__ == __stack_end__ || (__stack_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .stack is too large to fit in RAM1 memory segment");
  . = ASSERT(__heap_end__ <= __stack_start__ , "error: section .heap overlaps absolute placed section .stack");

  . = ASSERT(__STACKSIZE__  == ALIGN(__STACKSIZE__, 8), "error: .stack section size does not match alignment");

  . = ASSERT(__stack_size__ <= __STACKSIZE__ , "error: .stack section is larger than specified size");

  __stack_process_load_start__ = ALIGN(__stack_end__ , 8);
  .stack_process ALIGN(__stack_end__ , 8) (NOLOAD) : AT(ALIGN(__stack_end__ , 8))
  {
    __stack_process_start__ = .;
    *(.stack_process .stack_process.*)
    . = ALIGN(MAX(__stack_process_start__ + __STACKSIZE_PROCESS__ , .), 8);
  }
  __stack_process_end__ = __stack_process_start__ + SIZEOF(.stack_process);
  __stack_process_size__ = SIZEOF(.stack_process);
  __stack_process_load_end__ = __stack_process_end__;

  __RAM1_segment_used_end__ = ALIGN(__stack_end__ , 8) + SIZEOF(.stack_process);
  __RAM1_segment_used_size__ = __RAM1_segment_used_end__ - __RAM1_segment_start__;

  . = ASSERT(__stack_process_start__ == __stack_process_end__ || (__stack_process_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .stack_process is too large to fit in RAM1 memory segment");

  . = ASSERT(__STACKSIZE_PROCESS__  == ALIGN(__STACKSIZE_PROCESS__, 8), "error: .stack_process section size does not match alignment");

  . = ASSERT(__stack_process_size__ <= __STACKSIZE_PROCESS__ , "error: .stack_process section is larger than specified size");

}

