<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Support\StaticAdminData;
use Illuminate\Contracts\View\View;

class AdminController extends Controller
{
    public function dashboard(): View
    {
        return $this->page('admin.dashboard', 'Dashboard', [
            'stats' => StaticAdminData::dashboardStats(),
            'orders' => StaticAdminData::orders(),
            'orderStats' => StaticAdminData::orderStats(),
        ]);
    }

    public function users(): View
    {
        $users = StaticAdminData::users();

        return $this->page('admin.users', 'Users', [
            'users' => $users,
            'counts' => [
                'total' => count($users),
                'paid' => count(array_filter($users, fn ($u) => $u['payment_status'] === 'Paid')),
                'unpaid' => count(array_filter($users, fn ($u) => $u['payment_status'] === 'Unpaid')),
                'new' => count(array_filter($users, fn ($u) => $u['payment_status'] === 'New')),
            ],
        ]);
    }

    public function orders(): View
    {
        return $this->page('admin.orders', 'Orders', [
            'orders' => StaticAdminData::orders(),
            'orderStats' => StaticAdminData::orderStats(),
        ]);
    }

    public function leads(): View
    {
        $leads = StaticAdminData::leads();

        return $this->page('admin.leads', 'Leads', [
            'leads' => $leads,
            'total' => count($leads),
        ]);
    }

    public function settings(): View
    {
        return $this->page('admin.settings', 'Settings', [
            'company' => StaticAdminData::COMPANY,
        ]);
    }

    /** @param  array<string, mixed>  $data */
    private function page(string $view, string $title, array $data = []): View
    {
        return view($view, array_merge($data, [
            'pageTitle' => $title,
            'appName' => StaticAdminData::APP_NAME,
            'sidebar' => StaticAdminData::sidebar(),
            'adminUsername' => session('admin_username', 'admin'),
        ]));
    }
}
