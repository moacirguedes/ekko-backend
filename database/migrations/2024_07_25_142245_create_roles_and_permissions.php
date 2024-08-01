<?php

use Illuminate\Database\Migrations\Migration;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $adminRole = Role::create(['name' => 'admin']);
        $moderatorRole = Role::create(['name' => 'moderator']);
        $userRole = Role::create(['name' => 'user']);

        Permission::create(['name' => 'admin']);
        Permission::create(['name' => 'moderator']);
        Permission::create(['name' => 'user']);

        $adminRole->givePermissionTo(['admin']);
        $moderatorRole->givePermissionTo(['moderator']);
        $userRole->givePermissionTo(['user']);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Permission::where('name', 'admin')->delete();
        Permission::where('name', 'moderator')->delete();
        Permission::where('name', 'user')->delete();

        Role::where('name', 'admin')->delete();
        Role::where('name', 'moderator')->delete();
        Role::where('name', 'user')->delete();
    }
};
