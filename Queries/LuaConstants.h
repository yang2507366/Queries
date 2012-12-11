//
//  LuaConstants.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#define script_id_function_name     @"__app_id__()"
#define lua_self                    @"__self__"
#define lua_main_file               @"main"
#define lua_main_function           @"main"
#define lua_prefix_grammar          @"ios::"
#define lua_method_separator        @"::"
#define lua_obj_prefix              @"_obj_"
#define lua_dot_grammar             @"->"
#define lua_object_file             @"Object.lua"
#define lua_require_separator       @"/"
#define lua_app_bundle_dir          [NSString stringWithFormat:@"%@/Documents/bundles/", NSHomeDirectory()]
#define lua_super                   @"super:"
#define lua_ap_new                  "ap_new"
#define lua_ap_release              "ap_release"